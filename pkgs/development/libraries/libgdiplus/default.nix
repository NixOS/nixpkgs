{ stdenv, fetchurl, pkgconfig, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libjpeg, libpng
, libXrender, libexif }:

stdenv.mkDerivation rec {
  name = "libgdiplus-2.10.9";

  src = fetchurl {
    url = "https://download.mono-project.com/sources/libgdiplus/${name}.tar.bz2";
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

  hardeningDisable = [ "format" ];

  buildInputs =
    [ pkgconfig glib cairo fontconfig libtiff giflib
      libjpeg libpng libXrender libexif
    ]
    ++ stdenv.lib.optional stdenv.isDarwin Carbon;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libgdiplus.0.dylib $out/lib/libgdiplus.so
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
