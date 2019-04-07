{ stdenv, fetchurl, pkgconfig, libXft, cairo, harfbuzz
, libintl, gobject-introspection, darwin, fribidi, gnome3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, makeFontsConf, freefont_ttf
, meson, ninja, glib
}:

with stdenv.lib;

let
  pname = "pango";
  version = "1.43.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1lnxldmv1a12dq5h0dlq5jyzl4w75k76dp8cn360x2ijlm9w5h6j";
  };

  # FIXME: docs fail on darwin
  outputs = [ "bin" "dev" "out" ] ++ optional (!stdenv.isDarwin) "devdoc";

  nativeBuildInputs = [
    meson ninja
    pkgconfig gobject-introspection gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [
    harfbuzz fribidi
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
    Carbon
    CoreGraphics
    CoreText
  ]);
  propagatedBuildInputs = [ cairo glib libXft libintl ];

  patches = [
    (fetchurl {
      # Add gobject-2 to .pc file
      url = "https://gitlab.gnome.org/GNOME/pango/commit/546f4c242d6f4fe312de3b7c918a848e5172e18d.patch";
      sha256 = "034na38cq98vk8gggn3yfr65jmv3jgig8d25zg89wydrandp14yr";
    })
  ];

  mesonFlags = [
    "-Denable_docs=${if stdenv.isDarwin then "false" else "true"}"
  ];

  enableParallelBuilding = true;

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  doCheck = false; # /layout/valid-1.markup: FAIL

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = https://www.pango.org/;
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
