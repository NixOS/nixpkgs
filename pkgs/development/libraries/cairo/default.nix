{ stdenv, fetchurl, pkgconfig, libiconvOrEmpty, libintlOrEmpty
, expat, zlib, libpng, pixman, fontconfig, freetype, xlibs
, gobjectSupport ? true, glib
, xcbSupport ? true # no longer experimental since 1.12
, glSupport ? true, mesa_noglu ? null # mesa is no longer a big dependency
}:

assert glSupport -> mesa_noglu != null;

with { inherit (stdenv.lib) optional optionals; };

stdenv.mkDerivation rec {
  name = "cairo-1.12.14";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.xz";
    sha256 = "04xcykglff58ygs0dkrmmnqljmpjwp2qgwcz8sijqkdpz7ix3l4n";
  };

  nativeBuildInputs = [ pkgconfig ] ++ libintlOrEmpty ++ libiconvOrEmpty;

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
    ;

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
