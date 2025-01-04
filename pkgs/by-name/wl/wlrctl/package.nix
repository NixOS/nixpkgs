{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  pkg-config,
  scdoc,
  ninja,
  libxkbcommon,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "wlrctl";
  version = "0.2.2";

  src = fetchFromSourcehut {
    owner = "~brocellous";
    repo = "wlrctl";
    rev = "v${version}";
    sha256 = "sha256-5mDcCSHbZMbfXbksAO4YhELznKpanse7jtbtfr09HL0=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    meson
    pkg-config
    scdoc
    ninja
    wayland-scanner
  ];
  buildInputs = [
    libxkbcommon
    wayland
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=type-limits";

  meta = with lib; {
    description = "Command line utility for miscellaneous wlroots Wayland extensions";
    homepage = "https://git.sr.ht/~brocellous/wlrctl";
    license = licenses.mit;
    maintainers = with maintainers; [
      puffnfresh
      artturin
    ];
    platforms = platforms.linux;
    mainProgram = "wlrctl";
  };
}
