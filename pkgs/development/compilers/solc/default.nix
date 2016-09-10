{ stdenv, fetchFromGitHub, boost, cmake, jsoncpp }:

stdenv.mkDerivation rec {
  version = "0.4.1";
  name = "solc-${version}";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    rev = "v${version}";
    sha256 = "0ww8s0dngx6sbjyz7pr14xl3bbmfzx3nwc8xd9fx8ddg9682cwry";
  };

  patchPhase = ''
    echo >commit_hash.txt 4fc6fc2ca59579fae2472df319c2d8d31fe5bde5
  '';

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
