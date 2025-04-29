{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  gjs,
  gobject-introspection,
  gtksourceview5,
  gtk4,
  libadwaita,
  meson,
  ninja,
  wrapGAppsHook4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textcompare";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "josephmawa";
    repo = "TextCompare";
    tag = "v${finalAttrs.version}";
    hash = "sha256-npF2kCYeW/RGaS7x2FrHEX3BdmO8CXj47biOw9IZ4nk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils
    gjs
    gobject-introspection
    gtk4
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gtksourceview5
    libadwaita
  ];

  preFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'io.github.josephmawa.TextCompare';" $out/bin/io.github.josephmawa.TextCompare
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple desktop app to compare old and new text";
    homepage = "https://github.com/josephmawa/TextCompare";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "io.github.josephmawa.TextCompare";
    platforms = lib.lists.intersectLists lib.platforms.linux gjs.meta.platforms;
  };
})
