{ stdenv, fetchurl, kdelibs, cmake, gmp, qca2, boost, gettext, qt4, automoc4
, phonon, libgcrypt }:

let
  mp_ = "1.3";
  version = "1.${mp_}";
  version4 = "4.${mp_}";
in
stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "libktorrent";

  src = fetchurl {
    url = "http://ktorrent.org/downloads/${version4}/${name}.tar.bz2";
    sha256 = "0mvvx6mdfy0pyhk6lwwmmbd3pd2ai6n2rf5kdjqhpkm9wbrck85n";
  };

  buildNativeInputs = [ cmake automoc4 gettext ];
  buildInputs = [ kdelibs phonon gmp qca2 boost libgcrypt ];

  enableParallelBuilding = true;

  meta = {
    description = "A BiTtorrent library used by KTorrent";
    homepage = http://ktorrent.org;
    inherit (kdelibs.meta) platforms;
  };
}
