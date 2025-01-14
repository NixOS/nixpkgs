{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  curl,
  db,
  libgeotiff,
  xorg,
  motif,
  pcre,
  perl,
  proj,
  graphicsmagick,
  shapelib,
  libax25,
}:

stdenv.mkDerivation rec {
  pname = "xastir";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Release-${version}";
    hash = "sha256-EQXSfH4b5vMiprFcMXCUDNl+R1cHSj9CyhZnUPAMoCw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    db
    libgeotiff
    xorg.libXpm
    xorg.libXt
    motif
    pcre
    perl
    proj
    graphicsmagick
    shapelib
    libax25
  ];

  configureFlags = [ "--with-motif-includes=${motif}/include" ];

  postPatch = "patchShebangs .";

  meta = with lib; {
    description = "Graphical APRS client";
    homepage = "https://xastir.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.linux;
  };
}
