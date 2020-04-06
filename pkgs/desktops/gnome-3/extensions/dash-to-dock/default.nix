{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-dash-to-dock-unstable";
  version = "2020-03-19";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    # rev = "extensions.gnome.org-v" + version;
    rev = "c58004802b2eedfde96966a4ec0151fea2a1bd98";
    sha256 = "IjunykPFP2CbGcd8XVqhPuNUOUOOgDAQFIytLaoyqRg=";
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
