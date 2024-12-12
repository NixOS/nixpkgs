{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libtool,
  gettext,
  libpng,
  libjpeg,
  freetype,
  SDL,
  libGL,
  xorg,
  libmysqlclient,
  fontconfig,
  perl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libagar";
  version = "1.7.0";

  src = fetchurl {
    url = "https://stable.hypertriton.com/agar/agar-${finalAttrs.version}.tar.gz";
    hash = "sha256-FzE9IjteqU+foDA93YLtyO4OfMF5U984pe5rZ8uElEY=";
  };

  preConfigure = ''
    substituteInPlace configure \
      --replace-fail '_BSD_SOURCE' '_DEFAULT_SOURCE'
  '';

  configureFlags = [
    "--enable-nls=no"
    "--with-jpeg=${libjpeg.dev}"
    "--with-gl=${libGL}"
    "--with-mysql=${libmysqlclient}"
  ];

  nativeBuildInputs = [
    pkg-config
    libtool
    gettext
  ];

  buildInputs = [
    perl
    xorg.libXinerama
    SDL
    libGL
    libmysqlclient
    freetype
    libpng
    libjpeg
    fontconfig
  ];

  meta = {
    description = "Cross-platform GUI toolkit";
    homepage = "http://libagar.org/index.html";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ ramkromberg ];
    platforms = lib.platforms.linux;
  };
})
