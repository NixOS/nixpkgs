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
, gnome3
, gi-docgen
, makeFontsConf
, freefont_ttf
, meson
, ninja
, glib
, x11Support? !stdenv.isDarwin, libXft
}:

stdenv.mkDerivation rec {
  pname = "pango";
  version = "1.48.4";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ym3cvajy2asapj8xbhfpy05rak79afrhi32hiss0w900vxi72a1";
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
    "-Dgtk_doc=true"
  ] ++ lib.optionals (!x11Support) [
    "-Dxft=disabled" # only works with x11
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  doCheck = false; # test-font: FAIL

  postInstall = ''
    # So that devhelp can find this.
    # https://gitlab.gnome.org/GNOME/pango/merge_requests/293/diffs#note_1058448
    mkdir -p "$devdoc/share/devhelp"
    mv "$out/share/doc/pango/reference" "$devdoc/share/devhelp/books"
    rmdir -p --ignore-fail-on-non-empty "$out/share/doc/pango"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
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
