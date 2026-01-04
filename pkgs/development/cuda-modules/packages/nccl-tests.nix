# NOTE: Though NCCL tests is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  backendStdenv,
  _cuda,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  gitUpdater,
  lib,
  mpi,
  mpiSupport ? false,
  nccl,
  which,
}:
let
  inherit (_cuda.lib) _mkMetaBroken;
  inherit (lib) licenses maintainers teams;
  inherit (lib.attrsets) getBin getInclude getLib;
  inherit (lib.lists) optionals;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nccl-tests";
  version = "2.17.6";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl-tests";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F7F8UcBCX7nsuCNCzWHNY12QFtmYV10Jf785P39SHkM=";
  };

  postPatch = ''
    nixLog "patching $PWD/src/common.mk to remove NVIDIA's ccbin declaration"
    substituteInPlace ./src/common.mk \
      --replace-fail \
        '-ccbin $(CXX)' \
        ""
  '';

  nativeBuildInputs = [
    which
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cccl # <nv/target>
    cuda_cudart
    nccl
  ]
  ++ optionals mpiSupport [ mpi ];

  # NOTE: CUDA_HOME is expected to have the bin directory
  # TODO: This won't work with cross-compilation since cuda_nvcc will come from hostPackages by default (aka pkgs).
  makeFlags = [
    "CXXSTD=-std=c++17"
    "CUDA_HOME=${getBin cuda_nvcc}"
    "CUDA_INC=${getInclude cuda_cudart}/include"
    "CUDA_LIB=${getLib cuda_cudart}/lib"
    "NVCC_GENCODE=${flags.gencodeString}"
    "PREFIX=$(out)"
  ]
  ++ optionals mpiSupport [ "MPI=1" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    install -Dm755 \
      $(find build -type f -executable) \
      "$out/bin"
    runHook postInstall
  '';

  passthru = {
    brokenAssertions = [
      {
        message = "mpi is non-null when mpiSupport is true";
        assertion = mpiSupport -> mpi != null;
      }
    ];

    updateScript = gitUpdater {
      inherit (finalAttrs) pname version;
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Tests to check both the performance and the correctness of NVIDIA NCCL operations";
    homepage = "https://github.com/NVIDIA/nccl-tests";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = licenses.bsd3;
    broken = _mkMetaBroken finalAttrs;
    maintainers = with maintainers; [ jmillerpdt ];
    teams = [ teams.cuda ];
  };
})
