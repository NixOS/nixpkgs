{ lib, stdenv, fetchurl, autoreconfHook, boost, fastjet, gsl, hepmc2, lhapdf, rivet, zlib }:

stdenv.mkDerivation rec {
  pname = "thepeg";
  version = "2.2.3";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/thepeg/ThePEG-${version}.tar.bz2";
    hash = "sha256-8hRzGXp2H8MpF7CKjSTSv6+T/1fzRB/WBdqZrJ3l1Qs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ boost fastjet gsl hepmc2 lhapdf rivet zlib ];

  configureFlags = [
    "--with-hepmc=${hepmc2}"
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
