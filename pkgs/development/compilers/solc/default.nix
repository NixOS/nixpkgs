{ stdenv, fetchzip, fetchgit, boost, cmake }:

let
  version = "0.4.13";
  rev = "0fb4cb1ab9bb4b6cc72e28cc5a1753ad14781f14";
  sha256 = "0rhrm0bmk5s2358j40yx7dzr1938q17dchzflrxw6y7yvkhscxrm";
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
    substituteInPlace cmake/EthDependencies.cmake \
      --replace 'set(Boost_USE_STATIC_LIBS ON)'   \
                'set(Boost_USE_STATIC_LIBS OFF)'
  '';

  buildInputs = [ boost cmake ];

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
