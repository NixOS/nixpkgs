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
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "EasyScreenCast";
    repo = "EasyScreenCast";
    rev = finalAttrs.version;
    hash = "sha256-G4JDxaUfipn9asOXGw+OPVULOdV+OmzeK5aE/FSPGes=";
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

  meta = {
    description = "Simplifies the use of the video recording function integrated in gnome shell";
    homepage = "https://github.com/EasyScreenCast/EasyScreenCast";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
