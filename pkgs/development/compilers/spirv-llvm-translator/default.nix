{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, lit
, llvm_11
, spirv-headers
, spirv-tools
}:

stdenv.mkDerivation rec {
  pname = "SPIRV-LLVM-Translator";
  version = "unstable-2022-05-04";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    rev = "99420daab98998a7e36858befac9c5ed109d4920";
    sha256 = "sha256-/vUyL6Wh8hykoGz1QmT1F7lfGDEmG4U3iqmqrJxizOg=";
  };

  nativeBuildInputs = [ pkg-config cmake llvm_11.dev spirv-tools ];

  buildInputs = [ spirv-headers llvm_11 ];

  checkInputs = [ lit ];

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DLLVM_DIR=${llvm_11.dev}"
    "-DBUILD_SHARED_LIBS=YES"
    "-DLLVM_SPIRV_BUILD_EXTERNAL=YES"
    # RPATH of binary /nix/store/.../bin/llvm-spirv contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  # FIXME: CMake tries to run "/llvm-lit" which of course doesn't exist
  doCheck = false;

  makeFlags = [ "all" "llvm-spirv" ];

  postInstall = ''
    install -D tools/llvm-spirv/llvm-spirv $out/bin/llvm-spirv
  '';

  meta = with lib; {
    homepage    = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator";
    description = "A tool and a library for bi-directional translation between SPIR-V and LLVM IR";
    license     = licenses.ncsa;
    platforms   = platforms.all;
    maintainers = with maintainers; [ gloaming ];
  };
}
