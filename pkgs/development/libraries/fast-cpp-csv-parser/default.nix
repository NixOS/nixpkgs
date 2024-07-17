{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fast-cpp-csv-parser";
  version = "2021-01-03";

  src = fetchFromGitHub {
    owner = "ben-strasser";
    repo = pname;
    rev = "75600d0b77448e6c410893830df0aec1dbacf8e3";
    sha256 = "04kalwgsr8khqr1j5j13vzwaml268c5dvc9wfcwfs13wp3snqwf2";
  };

  installPhase = ''
    mkdir -p $out/lib/pkgconfig $out/include
    cp -r *.h $out/include/
    substituteAll ${./fast-cpp-csv-parser.pc.in} $out/lib/pkgconfig/fast-cpp-csv-parser.pc
  '';

  meta = with lib; {
    description = "A small, easy-to-use and fast header-only library for reading comma separated value (CSV) files";
    homepage = "https://github.com/ben-strasser/fast-cpp-csv-parser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
