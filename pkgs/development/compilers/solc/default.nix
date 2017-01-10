{ stdenv, fetchgit, boost, cmake, jsoncpp }:

stdenv.mkDerivation rec {
  version = "0.4.6";
  name = "solc-${version}";

  # Cannot use `fetchFromGitHub' because of submodules
  src = fetchgit {
    url = "https://github.com/ethereum/solidity";
    rev = "2dabbdf06f414750ef0425c664f861aeb3e470b8";
    sha256 = "0q1dvizx60f7l97w8241wra7vpghimc9x7gzb18vn34sxv4bqy9g";
  };

  patchPhase = ''
    echo >commit_hash.txt 2dabbdf06f414750ef0425c664f861aeb3e470b8
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
