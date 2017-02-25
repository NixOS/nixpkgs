{ stdenv, fetchgit, boost, cmake, jsoncpp }:

stdenv.mkDerivation rec {
  version = "0.4.8";
  name = "solc-${version}";

  # Cannot use `fetchFromGitHub' because of submodules
  src = fetchgit {
    url = "https://github.com/ethereum/solidity";
    rev = "60cc1668517f56ce6ca8225555472e7a27eab8b0";
    sha256 = "09mwah7c5ca1bgnqp5qgghsi6mbsi7p16z8yxm0aylsn2cjk23na";
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
