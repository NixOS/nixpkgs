{ lib, stdenv, fetchFromGitHub, boxfort, cmake, libcsptr, pkg-config, gettext
, dyncall , nanomsg, python3Packages }:

stdenv.mkDerivation rec {
  version = "2.3.3";
  pname = "criterion";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "Criterion";
    rev = "v${version}";
    sha256 = "0y1ay8is54k3y82vagdy0jsa3nfkczpvnqfcjm5n9iarayaxaq8p";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boxfort.dev
    dyncall
    gettext
    libcsptr
    nanomsg
  ];

  checkInputs = with python3Packages; [ cram ];

  cmakeFlags = [ "-DCTESTS=ON" ];
  doCheck = true;
  checkTarget = "criterion_tests test";

  outputs = [ "dev" "out" ];

  meta = with lib; {
    description = "A cross-platform C and C++ unit testing framework for the 21th century";
    homepage = "https://github.com/Snaipe/Criterion";
    license = licenses.mit;
    maintainers = with maintainers; [
      thesola10
      Yumasi
    ];
    platforms = platforms.unix;
  };
}
