{ stdenv, fetchurl, kdelibs, cmake, gmp, qca2, boost, gettext, qt47, automoc4,
  perl }:

stdenv.mkDerivation rec {
  name = "libktorrent-1.0.2";

  src = fetchurl {
    url = "${meta.homepage}/downloads/4.0.2/${name}.tar.bz2";
    sha256 = "11kh1mcijwzr2kf7hpxadggh346kdb5jy8rnmawhi9nc0i7wyjlw";
  };

# TODO: xfs.h
  buildInputs = [ cmake kdelibs gmp qca2 boost gettext qt47 automoc4 perl ];

  meta = {
    description = "A bittorrent library used in ktorrent";
    homepage = http://ktorrent.org;
  };
}
