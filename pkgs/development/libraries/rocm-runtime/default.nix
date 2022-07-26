{ stdenv
, lib
, fetchFromGitHub
, writeScript
, addOpenGLRunpath
, clang-unwrapped
, cmake
, xxd
, elfutils
, llvm
, numactl
, rocm-device-libs
, rocm-thunk }:

stdenv.mkDerivation rec {
  pname = "rocm-runtime";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCR-Runtime";
    rev = "rocm-${version}";
    hash = "sha256-IP5ylfUXOFkw9+Frfh+tNaZ83ozAbOK9kO2AzFVzzWk=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ cmake xxd ];

  buildInputs = [ clang-unwrapped elfutils llvm numactl ];

  cmakeFlags = [
   "-DBITCODE_DIR=${rocm-device-libs}/amdgcn/bitcode"
   "-DCMAKE_PREFIX_PATH=${rocm-thunk}"
  ];

  postPatch = ''
    patchShebangs image/blit_src/create_hsaco_ascii_file.sh
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
    maintainers = with maintainers; [ lovesegfault ];
  };
}
