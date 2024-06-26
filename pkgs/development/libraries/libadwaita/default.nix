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
, appstream
, fribidi
, glib
, gtk4
, gnome
, gsettings-desktop-schemas
, desktop-file-utils
, xvfb-run
, AppKit
, Foundation
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libadwaita";
  version = "1.5.1";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = finalAttrs.version;
    hash = "sha256-dH0VPIt6SGTDcb1I72cKnNlyqZ3dptvKmMDjOd17BfA=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    sassc
    vala
    gobject-introspection
    desktop-file-utils  # for validate-desktop-file
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ] ++ lib.optionals (!finalAttrs.doCheck) [
    "-Dtests=false"
  ];

  buildInputs = [
    appstream
    fribidi
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Foundation
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  nativeCheckInputs = [
    gnome.adwaita-icon-theme
  ] ++ lib.optionals (!stdenv.isDarwin) [
    xvfb-run
  ];

  # Tests had to be disabled on Darwin because test-button-content fails
  #
  # not ok /Adwaita/ButtonContent/style_class_button - Gdk-FATAL-CRITICAL:
  # gdk_macos_monitor_get_workarea: assertion 'GDK_IS_MACOS_MONITOR (self)' failed
  doCheck = !stdenv.isDarwin;
  separateDebugInfo = true;

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

    # Put all resources related to demo app into devdoc output.
    for d in applications icons metainfo; do
      moveToOutput "share/$d" "$devdoc"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = finalAttrs.pname;
    };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    changelog = "https://gitlab.gnome.org/GNOME/libadwaita/-/blob/${finalAttrs.src.rev}/NEWS";
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    mainProgram = "adwaita-1-demo";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ dotlambda ]);
    platforms = platforms.unix;
    pkgConfigModules = [ "libadwaita-1" ];
  };
})
