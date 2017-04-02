{ stdenv, fetchzip, fetchgit, boost, cmake }:

let jsoncpp = fetchzip {
  url = https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz;
  sha256 = "0jz93zv17ir7lbxb3dv8ph2n916rajs8i96immwx9vb45pqid3n0";
}; in

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
    substituteInPlace deps/jsoncpp.cmake \
      --replace https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz ${jsoncpp}
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
