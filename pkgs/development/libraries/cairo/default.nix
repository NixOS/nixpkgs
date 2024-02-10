{ lib, stdenv, fetchurl, fetchpatch, gtk-doc, meson, ninja, pkg-config, python3
, docbook_xsl, fontconfig, freetype, libpng, pixman, zlib
, x11Support? !stdenv.isDarwin || true, libXext, libXrender
, gobjectSupport ? true, glib
, xcbSupport ? x11Support, libxcb
, darwin
, testers
}:

let
  inherit (lib) optional optionals;
in stdenv.mkDerivation (finalAttrs: let
  inherit (finalAttrs) pname version;
in {
  pname = "cairo";
  version = "1.18.0";

  src = fetchurl {
    url = "https://cairographics.org/${if lib.mod (builtins.fromJSON (lib.versions.minor version)) 2 == 0 then "releases" else "snapshots"}/${pname}-${version}.tar.xz";
    hash = "sha256-JDoHNrl4oz3uKfnMp1IXM7eKZbVBggb+970cPUzxC2Q=";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev"; # very small
  separateDebugInfo = true;

  nativeBuildInputs = [
    gtk-doc
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    docbook_xsl
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreGraphics
    CoreText
    ApplicationServices
    Carbon
  ]);

  propagatedBuildInputs = [ fontconfig freetype pixman libpng zlib ]
    ++ optionals x11Support [ libXext libXrender ]
    ++ optionals xcbSupport [ libxcb ]
    ++ optional gobjectSupport glib
    ; # TODO: maybe liblzo but what would it be for here?

  mesonFlags = [
    "-Dgtk_doc=true"

    # error: #error config.h must be included before this header
    "-Dsymbol-lookup=disabled"

    # Only used in tests, causes a dependency cycle
    "-Dspectre=disabled"

    (lib.mesonEnable "glib" gobjectSupport)
    (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonEnable "xlib" x11Support)
    (lib.mesonEnable "xcb" xcbSupport)
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "--cross-file=${builtins.toFile "cross-file.conf" ''
      [properties]
      ipc_rmid_deferred_release = ${
        {
          linux = "true";
          freebsd = "true";
          netbsd = "false";
        }.${stdenv.hostPlatform.parsed.kernel.name} or
          (throw "Unknown value for ipc_rmid_deferred_release")
      }
    ''}"
  ];

  preConfigure = ''
    patchShebangs version.py
  '';

  enableParallelBuilding = true;

  doCheck = false; # fails

  postInstall = ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "$out/lib/pkgconfig/cairo.pc" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype.dev}/include/freetype2 -I${freetype.dev}/include|g'
  '' + lib.optionalString stdenv.isDarwin glib.flattenInclude;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "A 2D graphics library with support for multiple output devices";
    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, XCB, Quartz, Win32, image buffers, PostScript,
      PDF, and SVG file output.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';
    homepage = "http://cairographics.org/";
    license = with licenses; [ lgpl2Plus mpl10 ];
    pkgConfigModules = [
      "cairo-pdf"
      "cairo-ps"
      "cairo-svg"
    ] ++ lib.optional gobjectSupport "cairo-gobject";
    platforms = platforms.all;
  };
})
