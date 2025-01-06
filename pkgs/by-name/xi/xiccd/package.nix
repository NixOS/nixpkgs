{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libX11,
  libXrandr,
  glib,
  colord,
}:

stdenv.mkDerivation rec {
  pname = "xiccd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "agalakhov";
    repo = "xiccd";
    rev = "v${version}";
    sha256 = "159fyz5535lcabi5bzmxgmjdgxlqcjaiqgzr00mi3ax0i5fdldwn";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libX11
    libXrandr
    glib
    colord
  ];

  meta = {
    description = "X color profile daemon";
    homepage = "https://github.com/agalakhov/xiccd";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = lib.platforms.linux;
    mainProgram = "xiccd";
  };
}
