{ stdenv, fetchzip, fetchgit, boost, cmake }:

let jsoncpp = fetchzip {
  url = https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz;
  sha256 = "0jz93zv17ir7lbxb3dv8ph2n916rajs8i96immwx9vb45pqid3n0";
}; in

let commit = "68ef5810593e7c8092ed41d5f474dd43141624eb"; in

stdenv.mkDerivation rec {
  version = "0.4.11";
  name = "solc-${version}";

  # Cannot use `fetchFromGitHub' because of submodules
  src = fetchgit {
    url = "https://github.com/ethereum/solidity";
    rev = commit;
    sha256 = "13zycybf23yvf3hkf9zgw9gbc1y4ifzxaf7sll69bsn24fcyq961";
  };

  patchPhase = ''
    echo >commit_hash.txt ${commit}
    echo >prerelease.txt
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
