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
  version = "1.50.6";

  outputs = [ "bin" "out" "dev" ]
    ++ lib.optionals withDocs [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "qZi882iBw6wgSV1AvOswT06qkXW9KWfIVlZDTL2v6Go=";
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

  postFixup = lib.optionalString withDocs ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
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
