{ lib, stdenv, fetchFromGitHub, gettext, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-clipboard-indicator";
  version = "38";

  src = fetchFromGitHub {
    owner = "Tudmotu";
    repo = "gnome-shell-extension-clipboard-indicator";
    rev = "v${version}";
    sha256 = "FNrh3b6la2BuWCsriYP5gG0/KNbkFPuq/YTXTj0aJAI=";
  };

  uuid = "clipboard-indicator@tudmotu.com";

  nativeBuildInputs = [
    gettext
    glib
  ];

  makeFlags = [
    "INSTALLPATH=${placeholder "out"}/share/gnome-shell/extensions/${uuid}/"
  ];

  meta = with lib; {
    description = "Adds a clipboard indicator to the top panel and saves clipboard history";
    license = licenses.mit;
    maintainers = with maintainers; [ jonafato ];
    platforms = platforms.linux;
    homepage = "https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator";
  };
}
