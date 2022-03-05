{ lib
, stdenv
, fetchurl
, pkg-config
, cairo
, harfbuzz
, libintl
, libthai
, darwin
, fribidi
, gnome
, gi-docgen
, makeFontsConf
, freefont_ttf
, meson
, ninja
, glib
, python3
, x11Support? !stdenv.isDarwin, libXft
, withIntrospection ? (stdenv.buildPlatform == stdenv.hostPlatform)
, gobject-introspection
, withDocs ? (stdenv.buildPlatform == stdenv.hostPlatform)
}:

stdenv.mkDerivation rec {
  pname = "pango";
  version = "1.50.3";

  outputs = [ "bin" "out" "dev" ]
    ++ lib.optionals withDocs [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "St0F7fUcH7N1oczedJiRQSDiPLKA3XOVsa60QfGDikw=";
  };

  strictDeps = !withIntrospection;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson ninja
    glib # for glib-mkenum
    pkg-config
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ] ++ lib.optionals withDocs [
    gi-docgen
    python3
  ];

  buildInputs = [
    fribidi
    libthai
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
    Carbon
    CoreGraphics
    CoreText
  ]);

  propagatedBuildInputs = [
    cairo
    glib
    libintl
    harfbuzz
  ] ++ lib.optionals x11Support [
    libXft
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString withDocs}"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
  ] ++ lib.optionals (!x11Support) [
    "-Dxft=disabled" # only works with x11
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  doCheck = false; # test-font: FAIL

  postInstall = lib.optionalString withDocs ''
    # So that devhelp can find this.
    # https://gitlab.gnome.org/GNOME/pango/merge_requests/293/diffs#note_1058448
    mkdir -p "$devdoc/share/devhelp"
    mv "$out/share/doc/pango/reference" "$devdoc/share/devhelp/books"
    rmdir -p --ignore-fail-on-non-empty "$out/share/doc/pango"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';

    homepage = "https://www.pango.org/";
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin ] ++ teams.gnome.members;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
