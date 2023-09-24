{ config
, lib
, stdenv
, fetchurl
, docbook-xsl-nons
, expat
, fontconfig
, freetype
, gtk-doc
, libiconv
, libintl
, libpng
, meson
, ninja
, pixman
, pkg-config
, writeShellScript
, writeText
, zlib
, x11Support? !stdenv.isDarwin
, libXext
, libXrender
, gobjectSupport ? true
, glib
, xcbSupport ? x11Support
, libxcb
, xcbutil
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

  postPatch = let
    # despite the suffix this is not a python script - this allows
    # us to take control of the apparent version and avoid the
    # direct python dependency at the same time
    dummyVersionScript = writeShellScript "version.py" ''
      echo '${finalAttrs.version}'
    '';
  in ''
    rm version.py
    ln -s ${dummyVersionScript} version.py
  '';

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev"; # very small
  separateDebugInfo = true;

  nativeBuildInputs = [
    docbook-xsl-nons
    gtk-doc
    meson
    ninja
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
    ; # TODO: maybe liblzo but what would it be for here?

  mesonFlags = [
    "-Dtee=enabled"
    "-Dfreetype=enabled"
    "-Dgtk_doc=true"
    "-Dglib=${if gobjectSupport then "enabled" else "disabled"}"
    "-Dxcb=${if xcbSupport then "enabled" else "disabled"}"
    "-Dxlib=${if x11Support then "enabled" else "disabled"}"
    "-Dquartz=${if stdenv.isDarwin then "enabled" else "disabled"}"
    "-Dsymbol-lookup=disabled"  # avoid libbfd dependency
    "-Dspectre=disabled"
    "-Dtests=${if finalAttrs.finalPackage.doCheck then "enabled" else "disabled"}"
  ] ++ optional (stdenv.buildPlatform != stdenv.hostPlatform) (let
      # see https://marc.info/?l=cairo&m=135064523003805&w=2 and
      # https://gitlab.freedesktop.org/cairo/cairo/-/merge_requests/134
      crossFile = writeText "cross-file.conf" ''
        [properties]
        ipc_rmid_deferred_release = ${if stdenv.hostPlatform.isLinux then "true" else "false"}
      '';
    in
      "--cross-file=${crossFile}"
  );

  enableParallelBuilding = true;

  doCheck = false; # fails

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
      "cairo-pdf"
    ] ++ lib.optional gobjectSupport "cairo-gobject";
    platforms = platforms.all;
  };
})
