{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, python3 }:

stdenv.mkDerivation rec {
  version = "0.6.3";
  pname = "docopt.cpp";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = "docopt.cpp";
    rev = "v${version}";
    sha256 = "0cz3vv7g5snfbsqcf3q8bmd6kv5qp84gj3avwkn4vl00krw13bl7";
  };

  patches = [
    (fetchpatch {
      name = "python3-for-tests";
      url = "https://github.com/docopt/docopt.cpp/commit/b3d909dc952ab102a4ad5a1541a41736f35b92ba.patch";
      hash = "sha256-JJR09pbn3QhYaZAIAjs+pe28+g1VfgHUKspWorHzr8o=";
    })
  ];

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = ["-DWITH_TESTS=ON"];

  strictDeps = true;

  doCheck = true;

  postPatch = ''
    substituteInPlace docopt.pc.in \
      --replace "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@" \
                "@CMAKE_INSTALL_LIBDIR@"
  '';

  checkPhase = "python ./run_tests";

  meta = with lib; {
    description = "C++11 port of docopt";
    homepage = "https://github.com/docopt/docopt.cpp";
    license = with licenses; [ mit boost ];
    platforms = platforms.all;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
