{ stdenv, fetchurl, kdelibs, cmake, gmp, qca2, boost, gettext, qt4, automoc4
, phonon, libgcrypt }:

let
  mp_ = "3.1";
  version = "1.${mp_}";
  version4 = "4.${mp_}";
in
stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "libktorrent";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${version4}/${name}.tar.bz2";
    sha256 = "2fe11ccb4bf2028c3da11e52cde890f1b3a90560e548eac89a4f8e1558b09725";
  };

  nativeBuildInputs = [ cmake automoc4 gettext ];
  buildInputs = [ kdelibs phonon gmp qca2 boost libgcrypt ];

  enableParallelBuilding = true;

  meta = {
    description = "A BiTtorrent library used by KTorrent";
    homepage = http://ktorrent.pwsp.net;
    inherit (kdelibs.meta) platforms;
  };
}
