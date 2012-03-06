{ stdenv, fetchurl, pkgconfig, glib, cairo, fontconfig
, libtiff, giflib, libungif, libjpeg, libpng, monoDLLFixer
, libXrender, libexif }:

stdenv.mkDerivation rec {
  name = "libgdiplus-2.10.9";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/libgdiplus/${name}.tar.bz2";
    sha256 = "0klnbly2q0yx5p0l5z8da9lhqsjj9xqj06kdw2v7rnms4z1vdpkd";
  };

  patches =
    [ (fetchurl {
        url = http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/dev-dotnet/libgdiplus/files/libgdiplus-2.10.1-libpng15.patch?revision=1.1;
        sha256 = "130r0jm065pjvbz5dkx96w37vj1wqc8fakmi2znribs14g0bl65f";
      })
    ];

  patchFlags = "-p0";

  buildInputs =
    [ pkgconfig glib cairo fontconfig libtiff giflib libungif
      libjpeg libpng libXrender libexif
    ];
}
