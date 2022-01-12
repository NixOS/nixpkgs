{ lib, stdenv, fetchurl, boost, fastjet, gfortran, gsl, lhapdf, thepeg, zlib, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "herwig";
  version = "7.2.2";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/herwig/Herwig-${version}.tar.bz2";
    sha256 = "10y3fb33zsinr0z3hzap9rsbcqhy1yjqnv4b4vz21g7mdlw6pq2k";
  };

  nativeBuildInputs = [ autoconf automake libtool gfortran ];

  buildInputs = [ boost fastjet gsl thepeg zlib ]
    # There is a bug that requires for default PDF's to be present during the build
    ++ (with lhapdf.pdf_sets; [ CT14lo CT14nlo ]);

  postPatch = ''
    patchShebangs ./
  '';

  configureFlags = [
    "--with-thepeg=${thepeg}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A multi-purpose particle physics event generator";
    homepage = "https://herwig.hepforge.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
    broken = stdenv.isAarch64; # doesn't compile: ignoring return value of 'FILE* freopen...
  };
}
