{ stdenv, fetchurl, kdelibs, cmake, gmp, qca2, boost, gettext, qt4, automoc4
, phonon, libgcrypt }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "libktorrent";
  version = "1.1.1";

  src = fetchurl {
    url = "http://ktorrent.org/downloads/4.1.1/${name}.tar.bz2";
    sha256 = "06d93xpshxawz49hqh6pvypir4ygm1f781hs7yim5k6b7shivfs1";
  };

  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon gmp qca2 boost libgcrypt gettext ];

  enableParallelBuilding = true;

  meta = {
    description = "A BiTtorrent library used by KTorrent";
    homepage = http://ktorrent.org;
  };
}
