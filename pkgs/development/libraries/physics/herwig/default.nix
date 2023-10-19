{ lib, stdenv, fetchurl, boost, fastjet, gfortran, gsl, lhapdf, thepeg, zlib, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "herwig";
  version = "7.2.3";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/herwig/Herwig-${version}.tar.bz2";
    hash = "sha256-VZmJk3mwGwnjMaJCbXjTm39uwSbbJUPp00Cu/mqlD4Q=";
  };

  nativeBuildInputs = [ autoconf automake libtool gfortran ];

  buildInputs = [ boost fastjet gsl thepeg zlib ]
    # There is a bug that requires for default PDF's to be present during the build
    ++ (with lhapdf.pdf_sets; [ CT14lo CT14nlo ]);

  postPatch = ''
    patchShebangs ./

    # Fix failing "make install" being unable to find HwEvtGenInterface.so
    substituteInPlace src/defaults/decayers.in.in \
      --replace "read EvtGenDecayer.in" ""
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
