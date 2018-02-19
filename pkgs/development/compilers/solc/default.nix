{ stdenv, fetchzip, fetchFromGitHub, boost, cmake, z3 }:

let
  version = "0.4.20";
  rev = "3155dd8058672ce8f04bc2c0f2536cb549067d0a";
  sha256 = "0jgqi6rnyr8d3plbag1p0yp1s1fzvjjsk4yrv06v46bsvyx4lgcn";
  jsoncppURL = https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz;
  jsoncpp = fetchzip {
    url = jsoncppURL;
    sha256 = "0jz93zv17ir7lbxb3dv8ph2n916rajs8i96immwx9vb45pqid3n0";
  };
in

stdenv.mkDerivation {
  name = "solc-${version}";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    inherit rev sha256;
  };

  patches = [ ./shared_install.patch ];

  postPatch = ''
    echo >commit_hash.txt '${rev}'
    echo >prerelease.txt
    substituteInPlace cmake/jsoncpp.cmake \
      --replace '${jsoncppURL}' ${jsoncpp}
    substituteInPlace cmake/EthCompilerSettings.cmake \
      --replace 'add_compile_options(-Werror)' ""
  '';

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF -DTESTS=OFF -DBUILD_SHARED_LIBS=ON"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost z3 ];

  outputs = [ "out" "dev" ];

  meta = {
    description = "Compiler for Ethereum smart contract language Solidity";
    longDescription = "This package also includes `lllc', the LLL compiler.";
    homepage = https://github.com/ethereum/solidity;
    license = stdenv.lib.licenses.gpl3;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = [ stdenv.lib.maintainers.dbrock ];
    inherit version;
  };
}
