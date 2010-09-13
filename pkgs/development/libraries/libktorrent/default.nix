{ stdenv, fetchurl, kdelibs, cmake, gmp, qca2, boost, gettext, qt4, automoc4,
  perl, phonon }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "libktorrent";
  version = "1.0.3";

  src = fetchurl {
    url = "${meta.homepage}/downloads/4${builtins.substring 1
      (builtins.stringLength version) version}/${name}.tar.bz2";
    sha256 = "1yfayzbmi7im0pf4g7awn8lqianpr55xwbsldz7lyj9lc1a3xcgs";
  };

# TODO: xfs.h
  propagatedBuildInputs = [ kdelibs gmp boost qt4 phonon ];
  buildInputs = [ cmake automoc4 qca2 gettext perl ];

  meta = {
    description = "A bittorrent library used in ktorrent";
    homepage = http://ktorrent.org;
  };
}
