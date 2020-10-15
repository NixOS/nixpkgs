{ stdenv
, fetchFromGitHub
, glib
, gettext
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-dash-to-dock";
  version = "69";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    rev = "extensions.gnome.org-v" + version;
    hash = "sha256-YuLtC7E8dK57JSuFdbDQe5Ml+KQfl9qSdrHdVhFaNiE=";
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
