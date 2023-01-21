{ llvmPackages
, lib
, fetchFromGitHub
, cmake
, python3
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "c3c";
  version = "unstable-2021-07-30";

  src = fetchFromGitHub {
    owner = "c3lang";
    repo = pname;
    rev = "2246b641b16e581aec9059c8358858e10a548d94";
    sha256 = "VdMKdQsedDQCnsmTxO4HnBj5GH/EThspnotvrAscSqE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkPhase = ''
    ( cd ../resources/testproject; ../../build/c3c build )
    ( cd ../test; python src/tester.py ../build/c3c test_suite )
  '';

  installPhase = ''
    install -Dm755 c3c $out/bin/c3c
    cp -r lib $out
  '';

  meta = with lib; {
    description = "Compiler for the C3 language";
    homepage = "https://github.com/c3lang/c3c";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
