{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  makeWrapper,
  gdk-pixbuf,
  libwebp,
}:

let
  inherit (gdk-pixbuf) moduleDir;
  loadersPath = "${gdk-pixbuf.binaryDir}/webp-loaders.cache";
in
stdenv.mkDerivation rec {
  pname = "webp-pixbuf-loader";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "aruiz";
    repo = "webp-pixbuf-loader";
    rev = version;
    sha256 = "sha256-IJEweV2ACFp+Ua2ESrRUNApXWBg3NED60FDKijYO5TI=";
  };

  nativeBuildInputs = [
    gdk-pixbuf.dev
    meson
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    gdk-pixbuf
    libwebp
  ];

  mesonFlags = [
    "-Dgdk_pixbuf_moduledir=${placeholder "out"}/${moduleDir}"
  ];

  postPatch = ''
    # It looks for gdk-pixbuf-thumbnailer in this package's bin rather than the gdk-pixbuf bin. We need to patch that.
    substituteInPlace webp-pixbuf.thumbnailer.in \
      --replace "@bindir@/gdk-pixbuf-thumbnailer" "$out/libexec/gdk-pixbuf-thumbnailer-webp"
  '';

  postInstall = ''
    GDK_PIXBUF_MODULE_FILE="$out/${loadersPath}" \
    GDK_PIXBUF_MODULEDIR="$out/${moduleDir}" \
    gdk-pixbuf-query-loaders --update-cache

    # gdk-pixbuf disables the thumbnailer in cross-builds (https://gitlab.gnome.org/GNOME/gdk-pixbuf/-/commit/fc37708313a5fc52083cf10c9326f3509d67701f)
    # and therefore makeWrapper will fail because 'gdk-pixbuf-thumbnailer' the executable does not exist.
  ''
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    # It assumes gdk-pixbuf-thumbnailer can find the webp loader in the loaders.cache referenced by environment variable, breaking containment.
    # So we replace it with a wrapped executable.
    mkdir -p "$out/bin"
    makeWrapper "${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer" "$out/libexec/gdk-pixbuf-thumbnailer-webp" \
      --set GDK_PIXBUF_MODULE_FILE "$out/${loadersPath}"
  '';

  meta = with lib; {
    description = "WebP GDK Pixbuf Loader library";
    homepage = "https://github.com/aruiz/webp-pixbuf-loader";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.cwyc ];
    teams = [ teams.gnome ];
  };
}
