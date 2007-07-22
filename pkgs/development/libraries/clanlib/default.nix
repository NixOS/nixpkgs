{
stdenv, fetchurl, zlib,
libpng, libjpeg, libvorbis, libogg,
libX11, xf86vidmodeproto, libXxf86vm, libXmu, mesa
}:

stdenv.mkDerivation {
  name = "clanlib-0.8.0";
  src = fetchurl {
    url = http://www.clanlib.org/download/releases-0.8/ClanLib-0.8.0.tgz;
    sha256 = "1rjr601h3hisrhvpkrj00wirx5hyfbppv9rla400wx7a42xvvyfy";
  };

  buildInputs = [zlib libpng libjpeg
                 libvorbis libogg libX11
                 xf86vidmodeproto libXmu
                 mesa libXxf86vm
                ];
}
