{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-shell-dash-to-dock-${version}";
  version = "v57";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "97f6a0bb95b9f87d7a34a074c9b3624b65111794";
    sha256 = "0b9i89hpn9k63zcrbl4bhs7qfb70wh09870fwv2ik7hajm64kynn";
  };

  nativeBuildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "A dock for the Gnome Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = https://micheleg.github.io/dash-to-dock/;
  };
}
