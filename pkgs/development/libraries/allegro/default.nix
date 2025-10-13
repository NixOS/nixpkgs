{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  libXext,
  xorgproto,
  libX11,
  libXpm,
  libXt,
  libXcursor,
  alsa-lib,
  cmake,
  pkg-config,
  zlib,
  libpng,
  libvorbis,
  libXxf86dga,
  libXxf86misc,
  libXxf86vm,
  openal,
  libGLU,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "allegro";
  version = "4.4.3.1";

  src = fetchurl {
    url = "https://github.com/liballeg/allegro5/releases/download/${version}/allegro-${version}.tar.gz";
    sha256 = "1m6lz35nk07dli26kkwz3wa50jsrxs1kb6w1nj14a911l34xn6gc";
  };

  patches = [
    ./nix-unstable-sandbox-fix.patch
    ./encoding.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    texinfo
    libXext
    xorgproto
    libX11
    libXpm
    libXt
    libXcursor
    alsa-lib
    zlib
    libpng
    libvorbis
    libXxf86dga
    libXxf86misc
    libXxf86vm
    openal
    libGLU
    libGL
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with lib; {
    description = "Game programming library";
    homepage = "https://liballeg.org/";
    license = licenses.giftware;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
