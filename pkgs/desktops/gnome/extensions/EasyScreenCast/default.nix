{ lib, stdenv, fetchFromGitHub, substituteAll, glib, gnome, gettext, jq, intltool }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-EasyScreenCast";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "EasyScreenCast";
    repo = "EasyScreenCast";
    rev = version;
    hash = "sha256-+cH/gczCdxoSrLp5nD82Spo8bSGyRnUUut3Xkmr9f3o=";
  };

  patches = [
    (substituteAll {
      src = ./fix-gi-path.patch;
      gnomeShell = gnome.gnome-shell;
    })
  ];

  nativeBuildInputs = [
    glib gettext jq intltool
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  passthru.extensionUuid = "EasyScreenCast@iacopodeenosee.gmail.com";

  meta = with lib; {
    description = "Simplifies the use of the video recording function integrated in gnome shell";
    homepage = "https://github.com/EasyScreenCast/EasyScreenCast";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
    broken = true;
  };
}
