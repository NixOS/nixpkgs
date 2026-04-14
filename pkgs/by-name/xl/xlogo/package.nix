{
  lib,
  stdenv,
  fetchFromGitLab,
  libxt,
  libxmu,
  libxext,
  libxaw,
  libx11,
  libsm,
  autoreconfHook,
  pkg-config,
  util-macros,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlogo";
  version = "1.0.7";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xlogo";
    tag = "xlogo-${finalAttrs.version}";
    hash = "sha256-KjJhuiFVn34vEZbC7ds4MrcXCHq9PcIpAuaCGBX/EXc=";
  };

  nativeBuildInputs = [
    util-macros
    autoreconfHook
    pkg-config
  ];

  configureFlags = [ "--with-appdefaultdir=$out/share/X11/app-defaults" ];

  buildInputs = [
    libx11
    libxext
    libsm
    libxmu
    libxaw
    libxt
  ];

  meta = {
    description = "X Window System logo display demo";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xlogo";
    maintainers = with lib.maintainers; [ raboof ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = "xlogo";
  };
})
