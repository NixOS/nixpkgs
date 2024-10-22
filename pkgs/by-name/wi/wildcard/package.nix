{ lib
, blueprint-compiler
, cargo
, desktop-file-utils
, fetchFromGitLab
, libadwaita
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wildcard";
  version = "0.3.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Wildcard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jOv0l1vnfDePWF7SAbsBFipPAONliPdc47xj79BJ+rc=";
  };

  strictDeps = true;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-8jNNCcZRoLyOHdaWmYTOGD7Nf7NkmJ1MIxBXLJGrm5Y=";
    name = "wildcard-${finalAttrs.version}";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  meta = {
    description = "Test your regular expressions";
    longDescription = ''
      Wildcard gives you a nice and simple to use interface to test/practice regular expressions.
    '';
    homepage = "https://gitlab.gnome.org/World/Wildcard";
    downloadPage = "https://gitlab.gnome.org/World/Wildcard/-/releases/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "wildcard";
    platforms = lib.platforms.linux;
  };
})
