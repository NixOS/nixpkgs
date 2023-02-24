{ config, lib, stdenv, fetchurl, meson, ninja, ghostscript, pkg-config, libiconv
, libintl, expat, zlib, libpng, pixman, fontconfig, freetype
, x11Support? !stdenv.isDarwin, libXext, libXrender
, gobjectSupport ? true, glib
, xcbSupport ? x11Support, libxcb, xcbutil # no longer experimental since 1.12
, libGLSupported ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, glSupport ? x11Support && config.cairo.gl or (libGLSupported && stdenv.isLinux)
, libGL # libGLU libGL is no longer a big dependency
, pdfSupport ? true
, darwin
, testers
}:

let
  inherit (lib) optional optionals;
in stdenv.mkDerivation (finalAttrs: let
  inherit (finalAttrs) pname version;
in {
  pname = "cairo";
  version = "1.17.8";

  src = fetchurl {
    url = "https://cairographics.org/${if lib.mod (builtins.fromJSON (lib.versions.minor version)) 2 == 0 then "releases" else "snapshots"}/${pname}-${version}.tar.xz";
    sha256 = "sha256-WxDIiS0bWNcNPwultHhjoGEmL6VrnceUQWH4yLeDvGQ=";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # very small
  separateDebugInfo = true;

  postPatch = ''
    substituteInPlace meson.build --replace \
      "version: run_command(find_program('version.py'), check: true).stdout().strip()" \
      "version: '${version}'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    ghostscript
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
    ; # TODO: maybe liblzo but what would it be for here?

  mesonFlags= [
    "-Dtee=disabled"
    "-Dsymbol-lookup=disabled"
    "-Dspectre=disabled"
    "-Dtests=disabled"
  ] ++ (if stdenv.isDarwin then [
    "-Dquartz=enabled"
  ] else (optional xcbSupport "-Dxcb=enabled"
  )) ++ optional (!x11Support) "-Dxlib=disabled";

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = lib.optionalString stdenv.isDarwin glib.flattenInclude;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

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
    pkgConfigModules = [
      "cairo-ps"
      "cairo-svg"
    ] ++ lib.optional gobjectSupport "cairo-gobject"
      ++ lib.optional pdfSupport "cairo-pdf";
    platforms = platforms.all;
  };
})
