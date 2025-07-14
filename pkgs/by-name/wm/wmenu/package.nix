{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  meson,
  ninja,
  cairo,
  pango,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmenu";
  version = "0.2.0";

  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "adnano";
    repo = "wmenu";
    tag = finalAttrs.version;
    hash = "sha256-JkKA3MUfRLsZWgvDyiYdqb8u4nGSfboL6Ecy7poPW1k=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    cairo
    pango
    wayland
    libxkbcommon
    wayland-protocols
    scdoc
  ];

  meta = with lib; {
    description = "Efficient dynamic menu for Sway and wlroots based Wayland compositors";
    homepage = "https://codeberg.org/adnano/wmenu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      eken
      sweiglbosker
    ];
    mainProgram = "wmenu";
  };
})
