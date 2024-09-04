{ lib
, nixosTests
, stdenv
, fetchFromGitLab
, inih
, libdrm
, libinput
, libxkbcommon
, meson
, ninja
, pkg-config
, scdoc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unl0kr";
  version = "unl0kr-2.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "postmarketOS";
    repo = "buffybox";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-Q7Omunv7stL9zKDrdDRGc2wrh0wNUdrroAAwk/RPXfE=";
  };

  # This should be migrated to the new branch ASAP. This has to be changed and stuff

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
    homepage = "https://gitlab.com/postmarketOS/buffybox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
})
