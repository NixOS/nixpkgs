{ stdenv, fetchurl, pkgconfig, glib, cairo, fontconfig
, libtiff, giflib, libungif, libjpeg, libpng, monoDLLFixer
, libXrender, libexif }:

stdenv.mkDerivation rec {
  name = "libgdiplus-2.10.9";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/libgdiplus/${name}.tar.bz2";
    sha256 = "0klnbly2q0yx5p0l5z8da9lhqsjj9xqj06kdw2v7rnms4z1vdpkd";
  };

  NIX_LDFLAGS = "-lgif";

  patches =
    [ (fetchurl {
        url = "https://raw.github.com/MagicGroup/MagicSpecLib/master/libgdiplus/libgdiplus-2.10.1-libpng15.patch";
        sha256 = "130r0jm065pjvbz5dkx96w37vj1wqc8fakmi2znribs14g0bl65f";
      })
      ./giflib.patch
    ];

  patchFlags = "-p0";

  buildInputs =
    [ pkgconfig glib cairo fontconfig libtiff giflib libungif
      libjpeg libpng libXrender libexif
    ];
}
