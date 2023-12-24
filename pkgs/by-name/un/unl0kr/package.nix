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
  version = "2.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "cherrypicker";
    repo = "unl0kr";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-Q7Omunv7stL9zKDrdDRGc2wrh0wNUdrroAAwk/RPXfE=";
  };

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
    homepage = "https://gitlab.com/cherrypicker/unl0kr";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
})
