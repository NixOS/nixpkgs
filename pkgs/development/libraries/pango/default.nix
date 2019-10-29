{ stdenv, fetchurl, fetchpatch, pkgconfig, cairo, harfbuzz
, libintl, gobject-introspection, darwin, fribidi, gnome3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, makeFontsConf, freefont_ttf
, meson, ninja, glib
, x11Support? !stdenv.isDarwin, libXft
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
  propagatedBuildInputs = [ cairo glib libintl ] ++
    optional x11Support libXft;

  patches = [
    (fetchpatch {
      # Add gobject-2 to .pc file
      url = "https://gitlab.gnome.org/GNOME/pango/commit/546f4c242d6f4fe312de3b7c918a848e5172e18d.patch";
      sha256 = "1cqhy4xbwx3ad7z5d1ks7smf038b9as8c6qy84rml44h0fgiq4m2";
    })
    (fetchpatch {
      # Fixes CVE-2019-1010238
      url = "https://gitlab.gnome.org/GNOME/pango/commit/490f8979a260c16b1df055eab386345da18a2d54.diff";
      sha256 = "1s0qclbaknkx3dkc3n6mlmx3fnhlr2pkncqjkywprpvahmmypr7k";
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
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';

    homepage = https://www.pango.org/;
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
