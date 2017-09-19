{ stdenv, fetchurl, fetchpatch, pkgconfig, libXft, cairo, harfbuzz
, libintlOrEmpty, gobjectIntrospection, darwin
}:

with stdenv.lib;

let
  ver_maj = "1.40";
  ver_min = "11";
in
stdenv.mkDerivation rec {
  name = "pango-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${ver_maj}/${name}.tar.xz";
    sha256 = "5b11140590e632739e4151cae06b8116160d59e22bf36a3ccd5df76d1cf0383e";
  };

  patches = [
    # https://bugzilla.gnome.org/show_bug.cgi?id=785978#c9
    (fetchpatch rec {
      name = "pango-fix-gtk2-test-failures.patch";
      url = "https://bug785978.bugzilla-attachments.gnome.org/attachment.cgi?id=357690&action=diff&collapsed=&context=patch&format=raw&headers=1";
      sha256 = "055m2dllfr5pgw6bci72snw38f4hsyw1x7flj188c965ild8lq3a";
    })
  ];

  outputs = [ "bin" "dev" "out" "devdoc" ];

  buildInputs = [ gobjectIntrospection ];
  nativeBuildInputs = [ pkgconfig ]
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
       Carbon
       CoreGraphics
       CoreText
    ]);
  propagatedBuildInputs = [ cairo harfbuzz libXft ] ++ libintlOrEmpty;

  enableParallelBuilding = true;

  doCheck = false; # test-layout fails on 1.40.3 (fails to find font config)
  # jww (2014-05-05): The tests currently fail on Darwin:
  #
  # ERROR:testiter.c:139:iter_char_test: assertion failed: (extents.width == x1 - x0)
  # .../bin/sh: line 5: 14823 Abort trap: 6 srcdir=. PANGO_RC_FILE=./pangorc ${dir}$tst
  # FAIL: testiter

  configureFlags = optional stdenv.isDarwin "--without-x";

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

    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
