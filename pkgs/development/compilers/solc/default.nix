{ stdenv, fetchzip, fetchFromGitHub, boost, cmake }:

let
  version = "0.4.12";
  rev = "194ff033ae44944ac59aa7bd3da89ba94ec5893c";
  sha256 = "0ll6z2cc09nav0rsrdmgsd5vd8w233g908gvn09fb4a1k5db3x6c";
  jsoncppURL = https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz;
  jsoncpp = fetchzip {
    url = jsoncppURL;
    sha256 = "0jz93zv17ir7lbxb3dv8ph2n916rajs8i96immwx9vb45pqid3n0";
  };
in

stdenv.mkDerivation {
  name = "solc-${version}";

  # Cannot use `fetchFromGitHub' because of submodules
  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    inherit rev sha256;
  };

  patchPhase = ''
    echo >commit_hash.txt '${rev}'
    echo >prerelease.txt
    substituteInPlace deps/jsoncpp.cmake \
      --replace '${jsoncppURL}' ${jsoncpp}
    substituteInPlace cmake/EthCompilerSettings.cmake \
      --replace 'add_compile_options(-Werror)' ""
  '';

  buildInputs = [ boost cmake ];

  meta = {
    description = "Compiler for Ethereum smart contract language Solidity";
    longDescription = "This package also includes `lllc', the LLL compiler.";
    homepage = https://github.com/ethereum/solidity;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.dbrock ];
    inherit version;
  };
}
