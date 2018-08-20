{ stdenv, fetchurl, pkgconfig, libXft, cairo, harfbuzz
, libintl, gobjectIntrospection, darwin, fribidi
}:

with stdenv.lib;

let
  ver_maj = "1.42";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "pango-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${ver_maj}/${name}.tar.xz";
    sha256 = "0cnfgcya3wbs9m8g44cl5ww6wbp6qbw96qvsgkr8ymwqn9b6fnli";
  };

  outputs = [ "bin" "dev" "out" "devdoc" ];

  buildInputs = [ gobjectIntrospection ];
  nativeBuildInputs = [ pkgconfig ]
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
       Carbon
       CoreGraphics
       CoreText
    ]);
  propagatedBuildInputs = [ cairo harfbuzz libXft libintl fribidi ];

  enableParallelBuilding = true;

  configureFlags = optional stdenv.isDarwin "--without-x";

  doCheck = false; # fails 1 out of 12 tests with "Fontconfig error: Cannot load default config file"

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
