{
  lib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wildcard";
  version = "0.3.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Wildcard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8e3UWJ6PGhwvo/AB89VgkBfgsaNVa4g6hT9vBTmKlZQ=";
  };

  strictDeps = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-hoJsXoPmp0A6oIV1Rm7eXI2U2OIGrStmKzDdPQtI41A=";
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
