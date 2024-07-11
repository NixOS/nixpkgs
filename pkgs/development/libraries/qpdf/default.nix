{ lib
, stdenv
, fetchFromGitHub
, cmake
, libjpeg
, perl
, zlib

# for passthru.tests
, cups-filters
, pdfmixtool
, pdfslicer
, python3
}:

stdenv.mkDerivation rec {
  pname = "qpdf";
  version = "11.9.1";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    rev = "v${version}";
    hash = "sha256-DhrOKjUPgNo61db8av0OTfM8mCNebQocQWtTWdt002s=";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ zlib libjpeg ];

  preConfigure = ''
    patchShebangs qtest/bin/qtest-driver
    patchShebangs run-qtest
    # qtest needs to know where the source code is
    substituteInPlace CMakeLists.txt --replace "run-qtest" "run-qtest --top $src --code $src --bin $out"
  '';

  doCheck = true;

  passthru.tests = {
    inherit (python3.pkgs) pikepdf;
    inherit
      cups-filters
      pdfmixtool
      pdfslicer
    ;
  };

  meta = with lib; {
    homepage = "https://qpdf.sourceforge.io/";
    description = "C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = licenses.asl20; # as of 7.0.0, people may stay at artistic2
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
    changelog = "https://github.com/qpdf/qpdf/blob/v${version}/ChangeLog";
  };
}
