{ stdenv, fetchurl, boost, fastjet, gfortran, gsl, lhapdf, thepeg, zlib, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "herwig";
  version = "7.2.1";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/herwig/Herwig-${version}.tar.bz2";
    sha256 = "11m6xvardnk0i8x8b3dpwg4c4ncq0xmlfg2n5r5qmh6544pz7zyl";
  };

  nativeBuildInputs = [ autoconf automake libtool ];

  buildInputs = [ boost fastjet gfortran gsl thepeg zlib ]
    # There is a bug that requires for default PDF's to be present during the build
    ++ (with lhapdf.pdf_sets; [ CT14lo CT14nlo ]);

  postPatch = ''
    patchShebangs ./
  '';

  configureFlags = [
    "--with-thepeg=${thepeg}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A multi-purpose particle physics event generator";
    homepage = "https://herwig.hepforge.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
    broken = stdenv.isAarch64; # doesn't compile: ignoring return value of 'FILE* freopen...
  };
}
