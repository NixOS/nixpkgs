{ stdenv, fetchFromGitHub, boost, cmake, jsoncpp }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "solc-${version}";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    rev = "v${version}";
    sha256 = "1d5x3psz8a9z9jnm30aspfvrpd9kblr14cn5vyl21p27x2vdlzr4";
  };

  patchPhase = ''
    echo >commit_hash.txt af6afb0415761b53721f89c7f65064807f41cbd3
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
