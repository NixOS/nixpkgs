{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # nativeBuildInputs
  cmake,
  pip,
  setuptools,
  swig,
  wheel,
  autoAddDriverRunpath,

  # dependencies
  openmm,
  torch,
}:
let
  inherit (torch) cudaSupport cudaPackages;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "openmm-torch";
  version = "1.5.1";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openmm";
    repo = "openmm-torch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z9aw1ye9zcDTiS/2eBBoxqSjds+eB2aMeO04GzsH3aw=";
  };

  # Ensure pip will not try to query an online index + install to the output store path
  postPatch = ''
    substituteInPlace python/CMakeLists.txt \
      --replace-fail \
        '-m pip install .' \
        '-m pip install --no-index --no-build-isolation --no-deps --prefix=$ENV{out} .'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "OPENMM_DIR" "${openmm}")

    # Upstream's CMakeLists.txt registers OPENMM_DIR's lib directories as the build RPATH. CMake then
    # fails trying to rewrite the install RPATH because Nix's cc-wrapper has already baked the correct
    # RUNPATH (torch, openmm, ...) into the library at link time. Disable CMake's RPATH handling and
    # keep the Nix-set RUNPATH.
    (lib.cmakeBool "CMAKE_SKIP_RPATH" true)

    (lib.cmakeBool "NN_BUILD_CUDA_LIB" cudaSupport)
  ];

  nativeBuildInputs = [
    cmake
    pip
    setuptools
    swig
    wheel
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  env.NIX_LDFLAGS = toString (
    lib.optionals cudaSupport [
      # The CUDA platform references driver API (libcuda) symbols.
      # Upstream's CMake only links the driver library on Windows; on Linux it relies on it being on the
      # link path, which fails in the sandbox (the openmm CUDA libs point their RUNPATH at the impure
      # /run/opengl-driver/lib).

      # Link the driver stub explicitly so the symbols resolve; the real driver is found at runtime via
      # autoAddDriverRunpath, and removeStubsFromRunpath strips the stub path from the output.
      "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"

      "-lcuda"
    ]
  );

  buildInputs = [
    openmm
    torch
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc
  ];

  dependencies = [
    openmm
    torch
  ];

  # Install the python bindings
  postInstall = ''
    ${lib.optionalString cudaSupport ''
      # The Python extension only wraps the core TorchForce API; it must not link the CUDA driver
      # stub, otherwise importing it would require libcuda.so.1 at load time (absent in the sandbox
      # and on CPU-only hosts).
      export NIX_LDFLAGS="''${NIX_LDFLAGS//-lcuda/}"
    ''}
    make PythonInstall
  '';

  pythonImportsCheck = [ "openmmtorch" ];

  # No tests
  doCheck = false;

  meta = {
    description = "OpenMM plugin to define forces with neural networks";
    homepage = "https://github.com/openmm/openmm-torch";
    changelog = "https://github.com/openmm/openmm-torch/releases/tag/${finalAttrs.src.tag}";
    # https://github.com/openmm/openmm-torch/tree/master#license
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
