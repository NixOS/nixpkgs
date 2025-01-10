{
  lib,
  stdenv,
  back,
  base,
  gui,
  make,
  wrapGNUstepAppsHook,
  fetchurl,
  system_preferences,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gworkspace";
  version = "1.0.0";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/usr-apps/gworkspace-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-M7dV7RVatw8gdYHQlRi5wNBd6MGT9GqW04R/DoKNu6I=";
  };

  # additional dependencies:
  # - PDFKit framework from http://gap.nongnu.org/
  # - TODO: to --enable-gwmetadata, need libDBKit as well as sqlite!
  nativeBuildInputs = [
    make
    wrapGNUstepAppsHook
  ];
  buildInputs = [
    back
    base
    gui
    system_preferences
  ];
  configureFlags = [ "--with-inotify" ];

  meta = {
    description = "Workspace manager for GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "GWorkspace";
    maintainers = with lib.maintainers; [
      ashalkhakov
      matthewbauer
      dblsaiko
    ];
    platforms = lib.platforms.linux;
  };
})
