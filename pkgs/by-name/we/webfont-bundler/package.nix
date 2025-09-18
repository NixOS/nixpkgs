{
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  glib-networking,
  gobject-introspection,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  python3Packages,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "webfont-bundler";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "webfont-kit-generator";
    tag = finalAttrs.version;
    hash = "sha256-5TFsUSY6pJc/OwOklw5YocrleL9nzxKMVS1Bt6LPI/Q=";
  };

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    gobject-introspection
    gtk4 # For gtk4-update-icon-cache
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    gtk4
    gtksourceview5
    libadwaita
    libsoup_3
    (python3.withPackages (
      ps: with ps; [
        brotli
        fonttools
        pygobject3
      ]
    ))
  ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
    python3Packages.brotli
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Create @font-face kits easily";
    longDescription = "Webfont Bundler is a simple utility that allows you to generate woff, woff2 and the necessary CSS boilerplate from non-web font formats (otf and ttf).";
    changelog = "https://github.com/rafaelmardojai/webfont-kit-generator/releases/tag/${finalAttrs.version}";
    mainProgram = "webfontkitgenerator";
    homepage = "https://apps.gnome.org/WebfontKitGenerator/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ benediktbroich ];
    teams = [ teams.gnome-circle ];
    platforms = platforms.unix;
  };
})
