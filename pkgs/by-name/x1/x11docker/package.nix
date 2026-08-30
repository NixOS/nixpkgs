{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nx-libs,
  xrandr,
  xinit,
  xhost,
  xdpyinfo,
  xauth,
  libxcvt,
  getopt,
  gnugrep,
  gawk,
  ps,
  mount,
  iproute2,
  python3,
  jq,
  wmctrl,
  xdotool,
  xclip,
  xpra,
  weston,
  xwayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "x11docker";
  version = "7.8.0";
  src = fetchFromGitHub {
    owner = "mviereck";
    repo = "x11docker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mOxPNT6psRBTuTrMgASBTBr3dZzCSxanSkHKF84lmO8=";
  };
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  # Don't install `x11docker-gui`, because requires `kaptain` dependency
  installPhase = ''
    install -D x11docker "$out/bin/x11docker";
    wrapProgram "$out/bin/x11docker" \
      --prefix PATH : "${
        lib.makeBinPath [
          getopt
          gnugrep
          gawk
          ps
          mount
          iproute2
          nx-libs
          xdpyinfo
          xhost
          xinit
          python3
          jq
          libxcvt
          wmctrl
          xdotool
          xclip
          xpra
          xrandr
          xauth
          weston
          xwayland
        ]
      }"
  '';

  meta = {
    description = "Run graphical applications with Docker";
    homepage = "https://github.com/mviereck/x11docker";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "x11docker";
  };
})
