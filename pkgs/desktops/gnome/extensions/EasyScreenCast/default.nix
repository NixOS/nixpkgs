{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  glib,
  gnome-shell,
  gettext,
  jq,
  intltool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-EasyScreenCast";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "EasyScreenCast";
    repo = "EasyScreenCast";
    rev = finalAttrs.version;
    hash = "sha256-CK9ta+2Kf7IFKb+uQhI1AtdNkJZpBgIL7JDM3JqsV4c=";
  };

  patches = [
    (replaceVars ./fix-gi-path.patch {
      gnomeShell = gnome-shell;
    })
  ];

  nativeBuildInputs = [
    glib
    gettext
    jq
    intltool
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  passthru.extensionUuid = "EasyScreenCast@iacopodeenosee.gmail.com";

  meta = with lib; {
    description = "Simplifies the use of the video recording function integrated in gnome shell";
    homepage = "https://github.com/EasyScreenCast/EasyScreenCast";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
})
