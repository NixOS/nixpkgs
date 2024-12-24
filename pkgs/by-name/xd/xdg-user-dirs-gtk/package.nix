{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  intltool,
  pkg-config,
  xdg-user-dirs,
  wrapGAppsHook3,
  gtk3,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-user-dirs-gtk";
  version = "0.11";

  src = fetchurl {
    url = "mirror://gnome/sources/xdg-user-dirs-gtk/${lib.versions.majorMinor finalAttrs.version}/xdg-user-dirs-gtk-${finalAttrs.version}.tar.xz";
    hash = "sha256-U0vVY9PA4/jcvzV4y4qw5J07pByWbUd8ivlDg2QSHn0=";
  };

  patches = [
    # Fix cross: ./configure: line 7633: no: command not found
    (fetchpatch {
      url = "https://salsa.debian.org/gnome-team/xdg-user-dirs-gtk/-/raw/b047b613d5f18aebe8e9bca4e0a82b75b2d1f8c4/debian/patches/fix-pkg-config-cross-compilation.patch";
      hash = "sha256-QHq8hlX0SS+T6jtagMs9qApJCWFG1PHxftzoID2Nag4=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    xdg-user-dirs # for AC_PATH_PROG
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  postPatch = ''
    # Fetch translations from correct localedir.
    substituteInPlace update.c --replace-fail \
      'bindtextdomain ("xdg-user-dirs", GLIBLOCALEDIR);' \
      'bindtextdomain ("xdg-user-dirs", "${xdg-user-dirs}/share/locale");'
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ xdg-user-dirs ]}")
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "xdg-user-dirs-gtk";
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/xdg-user-dirs-gtk";
    description = "Companion to xdg-user-dirs that integrates it into the GNOME desktop and GTK applications";
    license = lib.licenses.gpl2Only;
    maintainers = lib.teams.gnome.members;
    platforms = lib.platforms.unix;
    mainProgram = "xdg-user-dirs-gtk-update";
  };
})
