{ stdenv, fetchurl, pkgconfig, libXft, cairo, harfbuzz
, libintlOrEmpty, gobjectIntrospection
}:

let
  ver_maj = "1.38";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "pango-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${ver_maj}/${name}.tar.xz";
    sha256 = "0v12gi7f01iq3z852pclpnmkbcksbvpcmiazmklkx1dd9fbpakhx";
  };

  outputs = [ "dev" "out" "bin" "doc" ];

  buildInputs = [ gobjectIntrospection ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ cairo harfbuzz libXft ] ++ libintlOrEmpty;

  enableParallelBuilding = true;

  doCheck = false; # test-layout fails on 1.38.0
  # jww (2014-05-05): The tests currently fail on Darwin:
  #
  # ERROR:testiter.c:139:iter_char_test: assertion failed: (extents.width == x1 - x0)
  # .../bin/sh: line 5: 14823 Abort trap: 6 srcdir=. PANGO_RC_FILE=./pangorc ${dir}$tst
  # FAIL: testiter

  meta = with stdenv.lib; {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = http://www.pango.org/;
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin urkud ];
    platforms = with platforms; linux ++ darwin;
  };
}
