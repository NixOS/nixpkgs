{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nx-libs,
  xorg,
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
stdenv.mkDerivation {
  pname = "x11docker";
  version = "7.6.0-unstable-2024-04-04";
  src = fetchFromGitHub {
    owner = "mviereck";
    repo = "x11docker";
    rev = "cb29a996597839239e482409b895353b1097ce3b";
    sha256 = "sha256-NYMr2XZ4m6uvuIGO+nzX2ksxtVLJL4zy/JebxeAvqD4=";
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
          xorg.xdpyinfo
          xorg.xhost
          xorg.xinit
          python3
          jq
          xorg.libxcvt
          wmctrl
          xdotool
          xclip
          xpra
          xorg.xrandr
          xorg.xauth
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
}
