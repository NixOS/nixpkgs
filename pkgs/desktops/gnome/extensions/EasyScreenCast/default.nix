{ lib, stdenv, fetchFromGitHub, substituteAll, glib, gnome, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-EasyScreenCast";
  version = "unstable-2020-11-25";

  src = fetchFromGitHub {
    # To make it work with gnome 3.38, using effectively: https://github.com/EasyScreenCast/EasyScreenCast/pull/276
    owner = "Ian2020";
    repo = "EasyScreenCast";
    rev = "b1ab4a999bc7110ecbf68b5fe42c37fa67d7cb0d";
    sha256 = "s9b0ITKUzgG6XOd1bK7i3mGxfc+T+UHrTZhBp0Ff8zQ=";
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

