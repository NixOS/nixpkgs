{
  lib,
  stdenv,
  fetchurl,
  gtk3,
  wrapGAppsHook3,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "xdaliclock";
<<<<<<< HEAD
  version = "2.49";

  src = fetchurl {
    url = "https://www.jwz.org/xdaliclock/xdaliclock-${version}.tar.gz";
    hash = "sha256-jRTlt8IYZZ6EDLyU7kLQ2bktQztnj15IUpqUBvntXU8=";
=======
  version = "2.48";

  src = fetchurl {
    url = "https://www.jwz.org/xdaliclock/xdaliclock-${version}.tar.gz";
    hash = "sha256-BZiqjTSSAgvT/56OJDcKh4pDP9uqVhR5cCx89H+5FLQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Note: don't change this to set sourceRoot, or updateAutotoolsGnuConfigScriptsHook
  # on aarch64 doesn't find the files to patch and the aarch64 build fails!
  preConfigure = "cd X11";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
  ];

  preInstall = ''
    mkdir -vp $out/bin $out/share/man/man1 $out/share/gsettings-schemas/$name/glib-2.0/schemas $out/share/pixmaps $out/share/applications

    # https://www.jwz.org/blog/2022/08/dali-clock-2-45-released/#comment-236762
    gappsWrapperArgs+=(--set MESA_GL_VERSION_OVERRIDE 3.1)
  '';

  installFlags = [
    "GTK_ICONDIR=${placeholder "out"}/share/pixmaps/"
    "GTK_APPDIR=${placeholder "out"}/share/applications/"
  ];

<<<<<<< HEAD
  meta = {
    description = "Clock application that morphs digits when they are changed";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = with lib.platforms; linux ++ freebsd;
    license = lib.licenses.free; # TODO BSD on Gentoo, looks like MIT
=======
  meta = with lib; {
    description = "Clock application that morphs digits when they are changed";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux ++ freebsd;
    license = licenses.free; # TODO BSD on Gentoo, looks like MIT
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    downloadPage = "http://www.jwz.org/xdaliclock/";
    mainProgram = "xdaliclock";
  };
}
