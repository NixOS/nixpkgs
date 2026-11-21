{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zuki-themes";
  version = "4.0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = "3345081724d2513c9517e5947d86f7c49737fddc";
    hash = "sha256-kUVNvMdeTKpBKPkYAsRuQH3qff5qedr8XdRlhvv7wtg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  # The GTK2 themes need gtk-engine-murrine, which is no longer packaged.
  mesonFlags = [ (lib.mesonBool "gtk2" false) ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Themes for GTK and Xfce";
    homepage = "https://github.com/lassekongo83/zuki-themes";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
