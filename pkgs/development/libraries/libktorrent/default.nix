{ stdenv, fetchurl, kdelibs, cmake, gmp, qca2, boost, gettext, qt4, automoc4
, phonon, libgcrypt }:

let
  mp_ = "2.1";
  version = "1.${mp_}-2";
  version4 = "4.${mp_}";
in
stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "libktorrent";

  src = fetchurl {
    url = "http://ktorrent.org/downloads/${version4}/${name}.tar.bz2";
    sha256 = "1b4ibkba27ivvjsh5s93xwlcgzvvwsgl6mcd8g96d1al05n2ccw9";
  };

  nativeBuildInputs = [ cmake automoc4 gettext ];
  buildInputs = [ kdelibs phonon gmp qca2 boost libgcrypt ];

  enableParallelBuilding = true;

  meta = {
    description = "A BiTtorrent library used by KTorrent";
    homepage = http://ktorrent.org;
    inherit (kdelibs.meta) platforms;
  };
}
