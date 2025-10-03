{
  fetchFromGitLab,
  fetchpatch2,
  inih,
  lib,
  libdrm,
  libinput,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  scdoc,
  stdenv,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unl0kr";
  version = "3.3.0-unstable-2025-06-12";

  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true; # to use its vendored lvgl
    rev = "dd30685f75f396ba9798e765c798342a5ea47370";
    hash = "sha256-l9bIcn5UkpAI6Z6W4rjj20lEAhJn+5GPaiGOVEtENhA=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    inih
    libdrm
    libinput
    libxkbcommon
  ];

  mesonInstallTags = [ "unl0kr" ];

  env.PKG_CONFIG_SYSTEMD_SYSTEMD_SYSTEM_UNIT_DIR = "${placeholder "out"}/lib/systemd/system";

  strictDeps = true;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Suite of graphical applications for the terminal";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/buffybox";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hustlerone ];
    mainProgram = "unl0kr";
    platforms = platforms.linux;
  };
})
