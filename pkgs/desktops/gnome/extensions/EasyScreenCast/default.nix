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
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "EasyScreenCast";
    repo = "EasyScreenCast";
    rev = finalAttrs.version;
    hash = "sha256-lmei80L3JOVCtm2L5uU3kBWCJlK+bn+V02LyimaqJ8k=";
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
