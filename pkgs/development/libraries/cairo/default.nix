{ stdenv, fetchurl, pkgconfig, libiconv
, libintl, expat, zlib, libpng, pixman, fontconfig, freetype, xorg
, gobjectSupport ? true, glib
, xcbSupport ? true # no longer experimental since 1.12
, glSupport ? true, libGL ? null # libGLU_combined is no longer a big dependency
, pdfSupport ? true
, darwin
}:

assert glSupport -> libGL != null;

let
  version = "1.16.0";
  inherit (stdenv.lib) optional optionals;
in stdenv.mkDerivation rec {
  name = "cairo-${version}";

  src = fetchurl {
    url = "https://cairographics.org/${if stdenv.lib.mod (builtins.fromJSON (stdenv.lib.versions.minor version)) 2 == 0 then "releases" else "snapshots"}/${name}.tar.xz";
    sha256 = "0c930mk5xr2bshbdljv005j3j8zr47gqmkry3q6qgvqky6rjjysy";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev"; # very small

  nativeBuildInputs = [
    pkgconfig
    libiconv
    libintl
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreGraphics
    CoreText
    ApplicationServices
    Carbon
  ]);

  propagatedBuildInputs =
    with xorg; [ libXext fontconfig expat freetype pixman zlib libpng libXrender ]
    ++ optionals xcbSupport [ libxcb xcbutil ]
    ++ optional gobjectSupport glib
    ++ optional glSupport libGL
    ; # TODO: maybe liblzo but what would it be for here?

  configureFlags = if stdenv.isDarwin then [
    "--disable-dependency-tracking"
    "--enable-quartz"
    "--enable-quartz-font"
    "--enable-quartz-image"
    "--enable-ft"
  ] else ([ "--enable-tee" ]
    ++ optional xcbSupport "--enable-xcb"
    ++ optional glSupport "--enable-gl"
    ++ optional pdfSupport "--enable-pdf"
  );

  preConfigure =
  # On FreeBSD, `-ldl' doesn't exist.
    stdenv.lib.optionalString stdenv.isFreeBSD
       '' for i in "util/"*"/Makefile.in" boilerplate/Makefile.in
          do
            cat "$i" | sed -es/-ldl//g > t
            mv t "$i"
          done
       ''
    +
    ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype.dev}/include/freetype2 -I${freetype.dev}/include|g'
    '';

  enableParallelBuilding = true;

  doCheck = false; # fails

  postInstall = stdenv.lib.optionalString stdenv.isDarwin glib.flattenInclude;

  meta = with stdenv.lib; {
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

    license = with licenses; [ lgpl2Plus mpl10 ];

    platforms = platforms.all;
  };
}
