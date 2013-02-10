{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, xcbSupport ? true # no longer experimental since 1.12
, gobjectSupport ? true, glib
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype, xlibs
, expat
, zlib, libpng, pixman
, gettext, libiconvOrEmpty
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation rec {
  name = "cairo-1.12.14";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha256 = "04xcykglff58ygs0dkrmmnqljmpjwp2qgwcz8sijqkdpz7ix3l4n";
  };

  buildInputs = with xlibs;
    [ pkgconfig x11 fontconfig libXrender expat ]
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

  preConfigure =
  # On FreeBSD, `-ldl' doesn't exist.
    (stdenv.lib.optionalString stdenv.isFreeBSD
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
