{ stdenv, fetchzip, fetchgit, boost, cmake, z3 }:

let
  version = "0.4.16";
  rev = "d7661dd97460250b4e1127b9e7ea91e116143780";
  sha256 = "1fd69pdhkkkvbkrxipkck1icpqkpdskjzar48a1yzdsx3l8s4lil";
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
