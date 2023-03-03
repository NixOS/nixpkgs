{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, IOKit
, cctools
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "2.0.1.post1";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    hash = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    cctools
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    IOKit
  ];

  cmakeFlags = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Some x86 tests are interrupted by signal 10
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;test_x86"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "https://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice luc65r ];
  };
}
