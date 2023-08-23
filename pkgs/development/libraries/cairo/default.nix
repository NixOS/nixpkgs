{ stdenv
, lib
, fetchFromGitLab
, docbook-xsl-nons
, gtk-doc
, meson
, ninja
, pkg-config
, python3
, darwin
, fontconfig
, freetype
, glib
, libpng
, lzo
, pixman
, zlib
, x11Support ? !stdenv.isDarwin
, libX11
, libXext
, libXrender
, xcbSupport ? x11Support
, libxcb
, writeText
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cairo";
  version = "1.17.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "cairo";
    repo = "cairo";
    rev = finalAttrs.version;
    hash = "sha256-RIWtQ/n4SjaB2SDVn0CVp5ydmVYA5oyQkCAwrkdF4EE=";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev"; # very small

  separateDebugInfo = true;

  nativeBuildInputs = [
    docbook-xsl-nons
    gtk-doc
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreGraphics
    CoreText
    ApplicationServices
    Carbon
  ]);

  propagatedBuildInputs = [
    fontconfig
    freetype
    glib
    libpng
    lzo
    pixman
    zlib
  ] ++ lib.optionals x11Support [
    libX11
    libXext
    libXrender
  ] ++ lib.optionals xcbSupport [
    libxcb
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dspectre=disabled" # only useful for tests
    "-Dsymbol-lookup=disabled"
    "-Dtee=enabled" # used by firefox
    "-Dtests=disabled"
    (lib.mesonEnable "xlib" x11Support)
    (lib.mesonEnable "xcb" xcbSupport)
  ] ++ (
    # The meson-cc-tests/ipc_rmid_deferred_release.c test program
    # won't do its job when cross compiling.
    let
      crossFile = writeText "cross-file.conf" ''
        [properties]
        ipc_rmid_deferred_release = 'false'
      '';
    in
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--cross-file=${crossFile}"
    ]
  );

  postPatch = ''
    patchShebangs version.py
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "A 2D graphics library with support for multiple output devices";
    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices. Currently supported output targets include the X Window
      System (via both Xlib and XCB), quartz, win32, and image buffers,
      as well as PDF, PostScript, and SVG file output.

      Cairo is designed to produce consistent output on all output media
      while taking advantage of display hardware acceleration when available
      (for example, through the X Render Extension).
    '';
    homepage = "http://cairographics.org/";
    license = with licenses; [ lgpl2Plus mpl10 ];
    pkgConfigModules = [ "cairo-ps" "cairo-svg" "cairo-gobject" ];
    platforms = platforms.all;
  };
})
