{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,

  meson,
  ninja,
  pkg-config,
  nodejs,
  npmHooks,
  desktop-file-utils,
  appstream-glib,
  gjs,
  gobject-introspection,
  glib,
  gtk3,
  python3,
  wrapGAppsHook4,

  libadwaita,
  xorg,

  nix-update-script,
}:
let
  prefix = "com.github.joseexposito";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "touche";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = "touche";
    tag = finalAttrs.version;
    hash = "sha256-yRZeVN6KW/FA4Z6Aa3EnvqE9TKEC2tEhFQFkmqMUm3E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    nodejs
    npmHooks.npmConfigHook
    desktop-file-utils # `desktop-file-validate`, `update-desktop-database`
    appstream-glib # `appstream-util`
    gjs
    gobject-introspection
    glib # `glib-compile-schemas`
    gtk3 # `gtk-update-icon-cache`
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    xorg.libX11
  ];

  npmDeps = fetchNpmDeps {
    pname = "touche-npm-deps";
    inherit (finalAttrs) version src;
    hash = "sha256-zm6nP7789rDcXqcDKS9z8XIoAlhCzKdscPSueL79dTM=";
  };

  preConfigure = ''
    patchShebangs bundle/scripts
  '';

  # gjs uses the invocation name to add gresource files
  # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L159
  # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L37
  # To work around this, we manually set the the name
  preFixup = ''
    mv $out/bin/${prefix}.touche $out/bin/touche
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => '${prefix}.touche';" $out/bin/touche
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop application to configure Touchégg";
    homepage = "https://github.com/JoseExposito/touche";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "touche";
  };
})
