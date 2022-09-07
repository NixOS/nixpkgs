{ lib
, stdenv
, fetchFromGitLab
, gi-docgen
, meson
, ninja
, pkg-config
, vala
, glib
, gobject-introspection
, gtk4
, gnome
, gsettings-desktop-schemas
, libadwaita
, xvfb-run
}:

stdenv.mkDerivation rec {
  pname = "libpanel";
  version = "1.0.alpha1";

  outputs = [ "out" "dev" "devdoc" ];
  #outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libpanel";
    rev = version;
    hash = "sha256-jN+NIJxvrAtuH8DN/pdWEmy+/BfXR7Cw2X/MBbLlT/s=";
  };

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    vala
  ];

  mesonFlags = lib.optionals (!doCheck) [
    "-Dtests=false"
  ];

  buildInputs = [
    gobject-introspection
    gtk4
    libadwaita
  ];

  checkInputs = [
    #gnome.adwaita-icon-theme
  ] ++ lib.optionals (!stdenv.isDarwin) [
    #xvfb-run
  ];

  doCheck = true;

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

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Helps you create IDE-like applications using GTK 4 and libadwaita.";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ zseri ]);
    platforms = platforms.unix;
  };
}
