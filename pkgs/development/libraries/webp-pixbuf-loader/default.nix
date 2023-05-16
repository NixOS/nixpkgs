{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, makeWrapper
, gdk-pixbuf
, libwebp
}:

let
  inherit (gdk-pixbuf) moduleDir;
<<<<<<< HEAD
  loadersPath = "${gdk-pixbuf.binaryDir}/webp-loaders.cache";
in
stdenv.mkDerivation rec {
  pname = "webp-pixbuf-loader";
  version = "0.2.2";
=======

  # turning lib/gdk-pixbuf-#.#/#.#.#/loaders into lib/gdk-pixbuf-#.#/#.#.#/loaders.cache
  # removeSuffix is just in case moduleDir gets a trailing slash
  loadersPath = (lib.strings.removeSuffix "/" gdk-pixbuf.moduleDir) + ".cache";
in
stdenv.mkDerivation rec {
  pname = "webp-pixbuf-loader";
  version = "0.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aruiz";
    repo = "webp-pixbuf-loader";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-TdZK2OTwetLVmmhN7RZlq2NV6EukH1Wk5Iwer2W/aHc=";
=======
    sha256 = "sha256-Za5/9YlDRqF5oGI8ZfLhx2ZT0XvXK6Z0h6fu5CGvizc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      --replace "@bindir@/gdk-pixbuf-thumbnailer" "$out/libexec/gdk-pixbuf-thumbnailer-webp"
=======
      --replace "@bindir@/gdk-pixbuf-thumbnailer" "$out/bin/webp-thumbnailer"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postInstall = ''
    GDK_PIXBUF_MODULE_FILE="$out/${loadersPath}" \
    GDK_PIXBUF_MODULEDIR="$out/${moduleDir}" \
    gdk-pixbuf-query-loaders --update-cache

    # It assumes gdk-pixbuf-thumbnailer can find the webp loader in the loaders.cache referenced by environment variable, breaking containment.
    # So we replace it with a wrapped executable.
    mkdir -p "$out/bin"
<<<<<<< HEAD
    makeWrapper "${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer" "$out/libexec/gdk-pixbuf-thumbnailer-webp" \
=======
    makeWrapper "${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer" "$out/bin/webp-thumbnailer" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
