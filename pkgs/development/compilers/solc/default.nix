{ stdenv, fetchzip, fetchgit, boost, cmake }:

let
  version = "0.4.12";
  rev = "194ff033ae44944ac59aa7bd3da89ba94ec5893c";
  sha256 = "0gkg3nay0625qmhxxxax1d1c4dl554ri3pkwd12qfg6g1w6j04w7";
  jsoncppURL = https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz;
  jsoncpp = fetchzip {
    url = jsoncppURL;
    sha256 = "0jz93zv17ir7lbxb3dv8ph2n916rajs8i96immwx9vb45pqid3n0";
  };
in

stdenv.mkDerivation {
  name = "solc-${version}";

  # Cannot use `fetchFromGitHub' because of submodules
  src = fetchgit {
    url = "https://github.com/ethereum/solidity";
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
