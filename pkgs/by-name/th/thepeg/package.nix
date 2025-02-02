{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  boost,
  fastjet,
  gsl,
  hepmc3,
  lhapdf,
  rivet,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "thepeg";
  version = "2.3.0";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    hash = "sha256-rDWXmuicKWCMqSwVakn/aKrOeloSoMkvCgGoM9LTRXI=";
  };

  patches = [
    # Rivet 4 support
    (fetchpatch {
      url = "https://github.com/hep-mirrors/thepeg/commit/d974704fe48876c13cb7f544cabcf6ef30c00f48.diff";
      hash = "sha256-HzyNigbhWzSpjvvYw3+LZvnrSoV6Pmzghw/5VY5nlqk=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    boost
    fastjet
    gsl
    hepmc3
    lhapdf
    rivet
    zlib
  ];

  configureFlags = [
    "--with-hepmc=${hepmc3}"
    "--with-hepmcversion=3"
    "--with-rivet=${rivet}"
    "--without-javagui"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Toolkit for High Energy Physics Event Generation";
    homepage = "https://herwig.hepforge.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
