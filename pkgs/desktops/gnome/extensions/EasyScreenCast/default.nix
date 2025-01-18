{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  glib,
  gnome-shell,
  gettext,
  jq,
  intltool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-EasyScreenCast";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "EasyScreenCast";
    repo = "EasyScreenCast";
    rev = finalAttrs.version;
    hash = "sha256-5PJB+lm4NKeNpS2vg9xaVl5aUR0Rofmt6sEKXfuGG6c=";
  };

  patches = [
    (substituteAll {
      src = ./fix-gi-path.patch;
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
