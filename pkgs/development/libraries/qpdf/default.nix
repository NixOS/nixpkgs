{ lib, stdenv, fetchFromGitHub, libjpeg, zlib, perl }:

stdenv.mkDerivation rec {
  pname = "qpdf";
  version = "10.6.3";

  src = fetchFromGitHub {
    owner = "qpdf";
    repo = "qpdf";
    rev = "release-qpdf-${version}";
    hash = "sha256-SiZA8T7N1SWlbCFosSqFosLDV/3Q7+ywvgq1iB4umdg=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib libjpeg ];

  preCheck = ''
    patchShebangs qtest/bin/qtest-driver
  '';

  doCheck = true;
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://qpdf.sourceforge.net/";
    description = "A C++ library and set of programs that inspect and manipulate the structure of PDF files";
    license = licenses.asl20; # as of 7.0.0, people may stay at artistic2
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
