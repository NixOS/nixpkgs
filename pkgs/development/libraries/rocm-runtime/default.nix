{ stdenv
, lib
, fetchFromGitHub
, rocmUpdateScript
, addOpenGLRunpath
, cmake
, pkg-config
, xxd
, elfutils
, libdrm
, llvm
, numactl
, rocm-device-libs
, rocm-thunk }:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-runtime";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCR-Runtime";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-M9kv1Oe5ZZfd9H/+KUJUoK9L1EdyS2qRp2mJDK0dnPE=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ cmake pkg-config xxd ];

  buildInputs = [ elfutils libdrm llvm numactl ];

  cmakeFlags = [ "-DCMAKE_PREFIX_PATH=${rocm-thunk}" ];

  postPatch = ''
    patchShebangs image/blit_src/create_hsaco_ascii_file.sh
    patchShebangs core/runtime/trap_handler/create_trap_handler_header.sh

    substituteInPlace CMakeLists.txt \
      --replace 'hsa/include/hsa' 'include/hsa'

    # We compile clang before rocm-device-libs, so patch it in afterwards
    substituteInPlace image/blit_src/CMakeLists.txt \
      --replace '-cl-denorms-are-zero' '-cl-denorms-are-zero --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode'
  '';

  fixupPhase = ''
    rm -rf $out/hsa
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/RadeonOpenCompute/ROCR-Runtime";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
  };
})
