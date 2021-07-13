{ lib
, fetchFromGitHub
, cmake
, lit
, llvmPackages_12
}:

llvmPackages_12.stdenv.mkDerivation rec {
  pname = "spirv-llvm-translator";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    rev = "v${version}";
    sha256 = "0d6v7h00z7ipcn2qlidma2fs5ywf85ji1k6gskw2mh5szwggcajg";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ llvmPackages_12.llvm ];

  checkInputs = [ lit ];

  cmakeFlags = [ "-DLLVM_INCLUDE_TESTS=ON"
                 "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
               ];
  # also make `llvm-spirv`
  postBuild = "make llvm-spirv";

  doCheck = true;

  postInstall = ''
    install -Dm755 tools/llvm-spirv/llvm-spirv -t ${placeholder "out"}/bin
  '';

  meta = with lib; {
    homepage    = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator";
    description = "A tool and a library for bi-directional translation between SPIR-V and LLVM IR";
    license     = licenses.ncsa;
    platforms   = platforms.all;
    maintainers = with maintainers; [ gloaming ];
  };
}
