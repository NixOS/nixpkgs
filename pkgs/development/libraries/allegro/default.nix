{ stdenv, fetchurl, texinfo, libXext, xorgproto, libX11
, libXpm, libXt, libXcursor, alsaLib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc
, libXxf86vm, openal, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "allegro-${version}";
  version="4.4.2";

  src = fetchurl {
    url = "https://github.com/liballeg/allegro5/releases/download/${version}/${name}.tar.gz";
    sha256 = "1p0ghkmpc4kwij1z9rzxfv7adnpy4ayi0ifahlns1bdzgmbyf88v";
  };

  patches = [
    ./allegro4-mesa-18.2.5.patch
    ./nix-unstable-sandbox-fix.patch
  ];

  buildInputs = [
    texinfo libXext xorgproto libX11 libXpm libXt libXcursor
    alsaLib cmake zlib libpng libvorbis libXxf86dga libXxf86misc
    libXxf86vm openal libGLU_combined
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with stdenv.lib; {
    description = "A game programming library";
    homepage = https://liballeg.org/;
    license = licenses.free; # giftware
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
