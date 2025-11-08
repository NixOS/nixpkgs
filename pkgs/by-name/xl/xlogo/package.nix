{
  lib,
  stdenv,
  fetchFromGitLab,
  xorg,
  autoreconfHook,
  pkg-config,
  util-macros,
}:

stdenv.mkDerivation rec {
  pname = "xlogo";
  version = "1.0.7";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xlogo";
    rev = "refs/tags/xlogo-${version}";
    hash = "sha256-KjJhuiFVn34vEZbC7ds4MrcXCHq9PcIpAuaCGBX/EXc=";
  };

  nativeBuildInputs = [
    util-macros
    autoreconfHook
    pkg-config
  ];

  configureFlags = [ "--with-appdefaultdir=$out/share/X11/app-defaults" ];

  buildInputs = [
    xorg.libX11
    xorg.libXext
    xorg.libSM
    xorg.libXmu
    xorg.libXaw
    xorg.libXt
  ];

  meta = with lib; {
    description = "X Window System logo display demo";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xlogo";
    maintainers = with maintainers; [ raboof ];
    platforms = platforms.unix;
    license = licenses.mit;
    mainProgram = "xlogo";
  };
}
