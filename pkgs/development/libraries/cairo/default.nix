{ stdenv, fetchurl, fetchpatch, pkgconfig, libiconv, libintlOrEmpty
, expat, zlib, libpng, pixman, fontconfig, freetype, xlibs
, gobjectSupport ? true, glib
, xcbSupport ? true # no longer experimental since 1.12
, glSupport ? true, mesa_noglu ? null # mesa is no longer a big dependency
, pdfSupport ? true
}:

assert glSupport -> mesa_noglu != null;

with { inherit (stdenv.lib) optional optionals; };

stdenv.mkDerivation rec {
  name = "cairo-1.14.0";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha1 = "53cf589b983412ea7f78feee2e1ba9cea6e3ebae";
  };

  patches = [(fetchpatch {
    name = "fix-racket.diff";
    url = "http://cgit.freedesktop.org/cairo/patch/?id=2de69581c28bf115852037ca41eba13cb7335976";
    sha256 = "0mk2fd9fwxqzravlmnbbrzwak15wqspn7609y0yn6qh87va5i0x4";
  })];

  nativeBuildInputs = [ pkgconfig libiconv ] ++ libintlOrEmpty;

  propagatedBuildInputs =
    with xlibs; [ xlibs.xlibs fontconfig expat freetype pixman zlib libpng ]
    ++ optional (!stdenv.isDarwin) libXrender
    ++ optionals xcbSupport [ libxcb xcbutil ]
    ++ optional gobjectSupport glib
    ++ optionals glSupport [ mesa_noglu ]
    ;

  configureFlags = [ "--enable-tee" ]
    ++ optional xcbSupport "--enable-xcb"
    ++ optional glSupport "--enable-gl"
    ++ optional pdfSupport "--enable-pdf"
    ;

  preConfigure =
  # On FreeBSD, `-ldl' doesn't exist.
    (stdenv.lib.optionalString stdenv.isFreeBSD
       '' for i in "util/"*"/Makefile.in" boilerplate/Makefile.in
          do
            cat "$i" | sed -es/-ldl//g > t
            mv t "$i"
          done
       '') 
       +
    ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype}/include/freetype2 -I${freetype}/include|g'
    '';

  enableParallelBuilding = true;

  # The default `--disable-gtk-doc' is ignored.
  postInstall = "rm -rf $out/share/gtk-doc"
    + stdenv.lib.optionalString stdenv.isDarwin (''
      #newline
    '' + glib.flattenInclude
    );

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

    license = [ "LGPLv2+" "MPLv1" ];

    platforms = stdenv.lib.platforms.all;
  };
}
