{ lib
, stdenv
, fetchFromGitLab
, docbook-xsl-nons
, gi-docgen
, gtk-doc
, libxml2
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
}:

stdenv.mkDerivation rec {
  pname = "libadwaita";
  version = "1.0.2";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = version;
    hash = "sha256-D7Qq8yAWkr/G5I4k8G1+viJkEJSrCBAg31Q+g3U9FcQ=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gi-docgen
    gtk-doc
    libxml2 # for xmllint
    meson
    ninja
    pkg-config
    sassc
    vala
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  buildInputs = [
    fribidi
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  checkInputs = [
    gnome.adwaita-icon-theme
    xvfb-run
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
    env "''${testEnvironment[@]}" xvfb-run \
      meson test --print-errorlogs

    runHook postCheck
  '';

  postInstall = ''
    mv $out/share/{doc,gtk-doc}
  '';

  meta = with lib; {
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ dotlambda ]);
    platforms = platforms.linux;
  };
}
