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

stdenv.mkDerivation (finalAttrs: {
  pname = "wlrctl";
  version = "0.2.2";

  src = fetchFromSourcehut {
    owner = "~brocellous";
    repo = "wlrctl";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Command line utility for miscellaneous wlroots Wayland extensions";
    homepage = "https://git.sr.ht/~brocellous/wlrctl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      puffnfresh
      artturin
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wlrctl";
  };
})
