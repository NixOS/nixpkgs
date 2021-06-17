{ config, lib, stdenv, fetchurl, fetchpatch, pkg-config, libiconv
, libintl, expat, zlib, libpng, pixman, fontconfig, freetype
, x11Support? !stdenv.isDarwin, libXext, libXrender
, gobjectSupport ? true, glib
, xcbSupport ? x11Support, libxcb, xcbutil # no longer experimental since 1.12
, libGLSupported ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, glSupport ? x11Support && config.cairo.gl or (libGLSupported && stdenv.isLinux)
, libGL ? null # libGLU libGL is no longer a big dependency
, pdfSupport ? true
, darwin
}:

assert glSupport -> x11Support && libGL != null;

let
  version = "1.17.4";
  inherit (lib) optional optionals;
in stdenv.mkDerivation rec {
  pname = "cairo";
  inherit version;

  src = fetchurl {
    url = "https://cairographics.org/${if lib.mod (builtins.fromJSON (lib.versions.minor version)) 2 == 0 then "releases" else "snapshots"}/${pname}-${version}.tar.xz";
    sha256 = "01cpjl0p8y7slqvx52kdcyw46h9zqhkkp6hpk5sfifrnshg4rckl";
  };

  patches = optionals stdenv.hostPlatform.isDarwin [
    # Workaround https://gitlab.freedesktop.org/cairo/cairo/-/issues/121
    ./skip-configure-stderr-check.patch
  ];

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev"; # very small

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libiconv
    libintl
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreGraphics
    CoreText
    ApplicationServices
    Carbon
  ]);

  propagatedBuildInputs = [ fontconfig expat freetype pixman zlib libpng ]
    ++ optionals x11Support [ libXext libXrender ]
    ++ optionals xcbSupport [ libxcb xcbutil ]
    ++ optional gobjectSupport glib
    ++ optional glSupport libGL
    ; # TODO: maybe liblzo but what would it be for here?

  configureFlags = (if stdenv.isDarwin then [
    "--disable-dependency-tracking"
    "--enable-quartz"
    "--enable-quartz-font"
    "--enable-quartz-image"
    "--enable-ft"
  ] else ([ "--enable-tee" ]
    ++ optional xcbSupport "--enable-xcb"
    ++ optional glSupport "--enable-gl"
    ++ optional pdfSupport "--enable-pdf"
  )) ++ optional (!x11Support) "--disable-xlib";

  preConfigure =
  # On FreeBSD, `-ldl' doesn't exist.
    lib.optionalString stdenv.isFreeBSD
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
    substituteInPlace configure --replace strings $STRINGS
    '';

  enableParallelBuilding = true;

  doCheck = false; # fails

  postInstall = lib.optionalString stdenv.isDarwin glib.flattenInclude;

  meta = with lib; {
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

    homepage = "http://cairographics.org/";

    license = with licenses; [ lgpl2Plus mpl10 ];

    platforms = platforms.all;
  };
}
