{ stdenv
, lib
, fetchFromGitHub
, writeScript
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

stdenv.mkDerivation rec {
  pname = "rocm-runtime";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCR-Runtime";
    rev = "rocm-${version}";
    hash = "sha256-26E7vA2JlC50zmpaQfDrFMlgjAqmfTdp9/A8g5caDqI=";
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

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/RadeonOpenCompute/ROCR-Runtime/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocm-runtime "$version"
  '';

  meta = with lib; {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/RadeonOpenCompute/ROCR-Runtime";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ lovesegfault Flakebi ];
  };
}
