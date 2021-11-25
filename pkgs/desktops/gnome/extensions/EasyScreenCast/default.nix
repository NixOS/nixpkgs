{ lib, stdenv, fetchFromGitHub, substituteAll, glib, gnome, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-EasyScreenCast";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "EasyScreenCast";
    repo = "EasyScreenCast";
    rev = version;
    sha256 = "sha256-+lh/hqYC9+DUvLE016KuAY4Ybw8KrqEEG7WG4pUbg2k=";
  };

  patches = [
    (substituteAll {
      src = ./fix-gi-path.patch;
      gnomeShell = gnome.gnome-shell;
    })
  ];

  nativeBuildInputs = [
    glib gettext
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
}

