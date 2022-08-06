{ lib
, stdenv
, fetchFromGitLab
, gi-docgen
, meson
, ninja
, pkg-config
, sassc
, vala
, gobject-introspection
, fribidi
, glib
, gtk4
, gnome
, gsettings-desktop-schemas
, xvfb-run
, AppKit
, Foundation
}:

stdenv.mkDerivation rec {
  pname = "libadwaita";
  version = "1.2.beta";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = version;
    hash = "sha256-QBblkeNAgfHi5YQxaV9ceqNDyDIGu8d6pvLcT6apm6o=";
  };

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    sassc
    vala
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ] ++ lib.optionals (!doCheck) [
    "-Dtests=false"
  ];

  buildInputs = [
    fribidi
    gobject-introspection
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Foundation
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  checkInputs = [
    gnome.adwaita-icon-theme
  ] ++ lib.optionals (!stdenv.isDarwin) [
    xvfb-run
  ];

  # Tests had to be disabled on Darwin because they fail with the same error as https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=264947 on Hydra:
  #
  # In file included from ../tests/test-style-manager.c:10:
  # ../src/adw-settings-private.h:16:10: fatal error: 'adw-enums-private.h' file not found
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck

    testEnvironment=(
      # Disable portal since we cannot run it in tests.
      ADW_DISABLE_PORTAL=1

      # AdwSettings needs to be initialized from “org.gnome.desktop.interface” GSettings schema when portal is not used for color scheme.
      # It will not actually be used since the “color-scheme” key will only have been introduced in GNOME 42, falling back to detecting theme name.
      # See adw_settings_constructed function in https://gitlab.gnome.org/GNOME/libadwaita/commit/60ec69f0a5d49cad8a6d79e4ecefd06dc6e3db12
      "XDG_DATA_DIRS=${glib.getSchemaDataDirPath gsettings-desktop-schemas}"

      # Tests need a cache directory
      "HOME=$TMPDIR"
    )
    env "''${testEnvironment[@]}" ${lib.optionalString (!stdenv.isDarwin) "xvfb-run"} \
      meson test --print-errorlogs

    runHook postCheck
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ dotlambda ]);
    platforms = platforms.unix;
  };
}
