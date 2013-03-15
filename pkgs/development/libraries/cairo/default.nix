{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, xcbSupport ? false
, gobjectSupport ? true, glib
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype, xlibs
, zlib, libpng, pixman, libxcb ? null, xcbutil ? null
, gettext, libiconvOrEmpty
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;
assert xcbSupport -> libxcb != null && xcbutil != null;

stdenv.mkDerivation rec {
  name = "cairo-1.12.4";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha1 = "f4158981ed01e73c94fb8072074b17feee61a68b";
  };

  buildInputs =
    [ pkgconfig x11 fontconfig ] 
    ++ stdenv.lib.optional (!stdenv.isDarwin) xlibs.libXrender
    ++ stdenv.lib.optionals xcbSupport [ libxcb xcbutil ]

    # On non-GNU systems we need GNU Gettext for libintl.
    ++ stdenv.lib.optional (!stdenv.isLinux) gettext

    ++ libiconvOrEmpty;

  propagatedBuildInputs =
    [ freetype pixman ] ++
    stdenv.lib.optional gobjectSupport glib ++
    stdenv.lib.optional postscriptSupport zlib ++
    stdenv.lib.optional pngSupport libpng;

  configureFlags =
    [ "--enable-tee" ]
    ++ stdenv.lib.optional xcbSupport "--enable-xcb"
    ++ stdenv.lib.optional pdfSupport "--enable-pdf";

  preConfigure = ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype}/include/freetype2 -I${freetype}/include|g'
  ''

  # On FreeBSD, `-ldl' doesn't exist.
  + (stdenv.lib.optionalString stdenv.isFreeBSD
       '' for i in "util/"*"/Makefile.in" boilerplate/Makefile.in
          do
            cat "$i" | sed -es/-ldl//g > t
            mv t "$i"
          done
       '');

  enableParallelBuilding = true;

  # The default `--disable-gtk-doc' is ignored.
  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A 2D graphics library with support for multiple output devices";

    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.  Experimental backends include OpenGL
      (through glitz), XCB, BeOS, OS/2, and DirectFB.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';

    homepage = http://cairographics.org/;

    licenses = [ "LGPLv2+" "MPLv1" ];

    platforms = stdenv.lib.platforms.all;
  };
}
