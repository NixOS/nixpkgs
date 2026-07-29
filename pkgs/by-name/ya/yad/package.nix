{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,
  gettext,
  gspell,
  gtk3,
  gtksourceview,
  libappindicator-gtk3,
  netpbm,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yad";
  version = "15.0";

  src = fetchFromGitHub {
    owner = "v1cont";
    repo = "yad";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-z+t4eG8yXhfs4GfLFDaaOCAxrr5MIoFD6BKF8vr59IY=";
  };

  configureFlags = [
    "--with-rgb=${placeholder "out"}/share/yad/rgb.txt"
    "--enable-html"
    "--enable-tray"
    "--enable-appindicator"
    "--enable-spell"
    "--enable-sourceview"
    "--enable-deprecated"
    "--enable-tools"
    "--enable-icon-browser"
  ];

  buildInputs = [
    gspell
    gtk3
    gtksourceview
    libappindicator-gtk3
    webkitgtk_4_1
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
    gettext
  ];

  postPatch = ''
    sed -i src/file.c -e '21i#include <glib/gprintf.h>'
    sed -i src/form.c -e '21i#include <stdlib.h>'

    # there is no point to bring in the whole netpbm package just for this file
    install -Dm644 ${netpbm.out}/share/netpbm/misc/rgb.txt $out/share/yad/rgb.txt
  '';

  meta = {
    homepage = "https://github.com/v1cont/yad";
    description = "GUI dialog tool for shell scripts";
    longDescription = ''
      Yad (yet another dialog) is a GUI dialog tool for shell scripts. It is a
      fork of Zenity with many improvements, such as custom buttons, additional
      dialogs, pop-up menu in notification icon and more.
    '';

    license = lib.licenses.gpl3;
    mainProgram = "yad";
    maintainers = with lib.maintainers; [ RoGreat ];
    platforms = with lib.platforms; linux;
  };
})
