{ stdenv
, fetchFromGitHub
, glib
, gettext
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-dash-to-dock-unstable";
  version = "2020-04-20";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    # rev = "extensions.gnome.org-v" + version;
    rev = "1788f31b049b622f78d0e65c56bef76169022ca9";
    sha256 = "1s8ychvs5l4mbjp8chc5nk62s4887q6vd3dj6spk4gimni2nayrk";
  };

  nativeBuildInputs = [
    glib
    gettext
  ];

  makeFlags = [
    "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions"
  ];

  uuid = "dash-to-dock@micxgx.gmail.com";

  meta = with stdenv.lib; {
    description = "A dock for the Gnome Shell";
    homepage = "https://micheleg.github.io/dash-to-dock/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo jtojnar ];
  };
}
