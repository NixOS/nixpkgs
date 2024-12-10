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
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "aruiz";
    repo = "webp-pixbuf-loader";
    rev = version;
    sha256 = "sha256-2GDH5+YCwb2mPdMfEscmWDOzdGnWRcppE+4rcDCZog4=";
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
    maintainers = teams.gnome.members ++ [ maintainers.cwyc ];
  };
}
