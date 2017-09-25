{ stdenv, fetchzip, fetchgit, boost, cmake, z3 }:

let
  version = "0.4.17";
  rev = "bdeb9e52a2211510644fb53df93fb98258b40a65";
  sha256 = "1x6q2rlq6gxggidgsy6li7m4phwr1hcfi65pq9yimz64ddqfiira";
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
    substituteInPlace cmake/jsoncpp.cmake \
      --replace '${jsoncppURL}' ${jsoncpp}
    substituteInPlace cmake/EthCompilerSettings.cmake \
      --replace 'add_compile_options(-Werror)' ""
  '';

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost z3 ];

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
