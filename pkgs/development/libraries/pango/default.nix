{ lib
, stdenv
, fetchurl
, pkg-config
, cairo
, harfbuzz
, libintl
, libthai
, gobject-introspection
, darwin
, fribidi
, gnome
, gi-docgen
, makeFontsConf
, freefont_ttf
, meson
, ninja
, glib
, x11Support? !stdenv.isDarwin, libXft
}:

let
  withDocs = stdenv.buildPlatform == stdenv.hostPlatform;
in
stdenv.mkDerivation rec {
  pname = "pango";
  version = "1.48.10";

  outputs = [ "bin" "out" "dev" ]
    ++ lib.optionals withDocs [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "IeH1eYvN/adeq8QoBRSwiWq1b2VtTn5mAwuaJTXs3Jg=";
  };

  nativeBuildInputs = [
    meson ninja
    glib # for glib-mkenum
    pkg-config
    gobject-introspection
    gi-docgen
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
  ] ++ lib.optionals (!x11Support) [
    "-Dxft=disabled" # only works with x11
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dintrospection=disabled"
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
