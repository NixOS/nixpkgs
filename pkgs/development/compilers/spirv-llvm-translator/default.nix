{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, lit
, llvm
, spirv-headers
, spirv-tools
}:

let
  llvmMajor = lib.versions.major llvm.version;

  branch =
    if llvmMajor == "15" then rec {
      version = "15.0.0";
      rev = "v${version}";
      hash = "sha256-111yL6Wh8hykoGz1QmT1F7lfGDEmG4U3iqmqrJxizOg=";
    } else if llvmMajor == "14" then rec{
      version = "14.0.0";
      rev = "v${version}";
      hash = "sha256-BhNAApgZ/w/92XjpoDY6ZEIhSTwgJ4D3/EfNvPmNM2o=";
    } else if llvmMajor == "11" then {
      version = "unstable-2022-05-04";
      rev = "99420daab98998a7e36858befac9c5ed109d4920"; # 265 commits ahead of v11.0.0
      hash = "sha256-/vUyL6Wh8hykoGz1QmT1F7lfGDEmG4U3iqmqrJxizOg=";
    } else throw "Incompatible LLVM version.";
in
stdenv.mkDerivation rec {
  pname = "SPIRV-LLVM-Translator";
  inherit (branch) version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    inherit (branch) rev hash;
  };

  nativeBuildInputs = [ pkg-config cmake llvm.dev spirv-tools ];

  buildInputs = [ spirv-headers llvm ];

  checkInputs = [ lit ];

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DLLVM_DIR=${llvm.dev}"
    "-DBUILD_SHARED_LIBS=YES"
    "-DLLVM_SPIRV_BUILD_EXTERNAL=YES"
    # RPATH of binary /nix/store/.../bin/llvm-spirv contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optionals (llvmMajor != "11") [ "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers.src}" ];

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
