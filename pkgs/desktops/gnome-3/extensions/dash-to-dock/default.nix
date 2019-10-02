{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-dash-to-dock";
  version = "20190921";

  src = fetchFromGitHub {
    owner = "micheleg";
    repo = "dash-to-dock";
    # rev = "extensions.gnome.org-v" + version;
    rev = "d918d29a6afced8823dc954a4317988b79aad6b8";
    sha256 = "1wlmbcn8zs8xiyxhgdcbnf2igjsjg0bkcsvjpy8fk13fxshxsqx6";
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
