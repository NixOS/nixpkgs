{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  gtk-doc,
  itstool,
  glib,
  gtk-layer-shell,
  gtk3,
  libmateweather,
  libwnck,
  librsvg,
  libxml2,
  dconf,
  dconf-editor,
  mate-common,
  mate-desktop,
  mate-menus,
  hicolor-icon-theme,
  wayland,
  gobject-introspection,
  wrapGAppsHook3,
  yelp-tools,
  marco,
  gitUpdater,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-panel";
  version = "1.28.7";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-panel";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    tag = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
    hash = "sha256-8GS6JY5kS2YKscItAo8dzudgkZeG51JsSBUj0EfLiZQ=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    gobject-introspection
    gettext
    gtk-doc
    itstool
    libxml2 # xmllint
    mate-common # mate-common.m4 macros
    pkg-config
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    gtk-layer-shell
    libmateweather
    libwnck
    librsvg
    dconf
    mate-desktop
    mate-menus
    hicolor-icon-theme
    wayland
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    # Optionally for the ca.desrt.dconf-editor.Settings schema
    # This is propagated for mate_panel_applet_settings_new and applet's wrapGAppsHook3
    dconf-editor
  ];

  # Needed for Wayland support.
  configureFlags = [ "--with-in-process-applets=all" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Workspace switcher settings, works only when passed after gtk3 schemas in the wrapper for some reason
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath marco}"
    )
  '';

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    odd-unstable = true;
  };

<<<<<<< HEAD
  meta = {
    description = "MATE panel";
    homepage = "https://github.com/mate-desktop/mate-panel";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "MATE panel";
    homepage = "https://github.com/mate-desktop/mate-panel";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
