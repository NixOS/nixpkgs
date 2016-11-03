{ stdenv, fetchFromGitHub, boost, cmake, jsoncpp }:

stdenv.mkDerivation rec {
  version = "0.4.4";
  name = "solc-${version}";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    rev = "v${version}";
    sha256 = "150prr7m0jnx3vhq0wy3avzsijxd3pn7c8jxdvf6jkcc408dgn6z";
  };

  patchPhase = ''
    echo >commit_hash.txt 4633f3def897db0f91237f98cf46e5d84fb05e61
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
