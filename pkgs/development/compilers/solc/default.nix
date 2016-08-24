{ stdenv, fetchFromGitHub, boost, cmake, jsoncpp }:

stdenv.mkDerivation rec {
  version = "0.3.6";
  name = "solc-${version}";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    rev = "v${version}";
    sha256 = "1cynqwy8wr63l3l4wv9z6shhcy6lq0q8pbsh3nav0dg9qgj9sg57";
  };

  buildInputs = [ boost cmake jsoncpp ];

  meta = {
    description = "Compiler for Ethereum smart contract language Solidity";
    longDescription = "This package also includes `lllc', the LLL compiler.";
    homepage = https://github.com/ethereum/solidity;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.dbrock ];
    inherit version;
  };
}
