{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
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
  version = "1.3.rc";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    rev = version;
    hash = "sha256-Xb1sNT1KpWspRkjuPBcAaRMXtVpXnjhm+V2FkNthEKk=";
  };

  patches = [
    # Fixes for the broken carousel test
    # https://github.com/NixOS/nixpkgs/pull/218143#issuecomment-1456610692
    # https://gitlab.gnome.org/GNOME/libadwaita/-/merge_requests/786
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libadwaita/-/commit/cbfd8e57d5ba684c8744f6955e0435e7a09b993e.patch";
      hash = "sha256-nVJD5Eu4gjyfIJf4/6e/ah10/dSxjLk5weWKxSP8byE=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libadwaita/-/commit/78dc3b1dc8527b29c8610a1ad3dee82c8b2b3771.patch";
      hash = "sha256-Nthf5crWjNlAPI+8SQ7YfUBCcmCJrHcfkpankqSm+Ic=";
    })
  ];

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
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ] ++ lib.optionals (!doCheck) [
    "-Dtests=false"
  ];

  buildInputs = [
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
    changelog = "https://gitlab.gnome.org/GNOME/libadwaita/-/blob/${src.rev}/NEWS";
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ dotlambda ]);
    platforms = platforms.unix;
  };
}
