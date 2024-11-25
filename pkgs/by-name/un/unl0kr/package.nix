{
  lib,
  nixosTests,
  stdenv,
  fetchFromGitLab,
  inih,
  libdrm,
  libinput,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unl0kr";
  version = "3.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "postmarketOS";
    repo = "buffybox";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-nZX7mSY9IBIhVNmOD6mXI1IF2TgyKLc00a8ADAvVLB0=";
  };

  sourceRoot = "${finalAttrs.src.name}/unl0kr";

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

  propagatedBuildInputs = [
    libxkbcommon
  ];

  passthru = {
    tests.unl0kr = nixosTests.systemd-initrd-luks-unl0kr;
  };

  meta = with lib; {
    description = "Framebuffer-based disk unlocker for the initramfs based on LVGL";
    mainProgram = "unl0kr";
    homepage = "https://gitlab.com/cherrypicker/unl0kr";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hustlerone ];
    platforms = platforms.linux;
  };
})
