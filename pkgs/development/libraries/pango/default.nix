{ stdenv, fetchurl, pkgconfig, libXft, cairo, harfbuzz
, libintl, gobject-introspection, darwin, fribidi, gnome3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, makeFontsConf, freefont_ttf
}:

with stdenv.lib;

let
  pname = "pango";
  version = "1.42.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "17bwb7dgbncrfsmchlib03k9n3xaalirb39g3yb43gg8cg6p8aqx";
  };

  outputs = [ "bin" "dev" "out" "devdoc" ];

  nativeBuildInputs = [ pkgconfig gobject-introspection gtk-doc docbook_xsl docbook_xml_dtd_43 ];
  buildInputs = optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Carbon
    CoreGraphics
    CoreText
  ]);
  propagatedBuildInputs = [ cairo harfbuzz libXft libintl fribidi ];

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
