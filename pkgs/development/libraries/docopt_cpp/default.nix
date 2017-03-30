{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  version = "0.6.2";
  name = "docopt.cpp-${version}";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.cpp";
    rev = "v${version}";
    sha256 = "1rgkc8nsc2zz2lkyai0y68vrd6i6kbq63hm3vdza7ab6ghq0n1dd";
  };

  nativeBuildInputs = [ cmake python ];

  cmakeFlags = ["-DWITH_TESTS=ON"];

  doCheck = true;

  checkPhase = "LD_LIBRARY_PATH=$(pwd) python ./run_tests";

  meta = with stdenv.lib; {
    description = "C++11 port of docopt";
    homepage = https://github.com/docopt/docopt.cpp;
    license = with licenses; [ mit boost ];
    platforms = platforms.all;
    maintainers = with maintainers; [ knedlsepp ];
  };
}

