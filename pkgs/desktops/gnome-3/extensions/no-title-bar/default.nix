{ stdenv, fetchFromGitHub, substituteAll, glib, gettext, xorg }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-no-title-bar";
  version = "2020-05-14";

  src = fetchFromGitHub {
    owner = "poehlerj";
    repo = "no-title-bar";
    rev = "4115905e1d3df51072a2c6b173a471667181b31a";
    sha256 = "0hcbbfapk76lr8yajacx59cyzs2c1dnccf8fq3gv3zk1z8jfqb1h";
  };

  nativeBuildInputs = [ glib gettext ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      xprop = "${xorg.xprop}/bin/xprop";
      xwininfo = "${xorg.xwininfo}/bin/xwininfo";
    })
  ];

  makeFlags = [ "INSTALLBASE=$(out)/share/gnome-shell/extensions" ];

  uuid = "no-title-bar@jonaspoehler.de";

  meta = with stdenv.lib; {
    description = "Integrates maximized windows with the top panel";
    homepage = "https://github.com/poehlerj/no-title-bar";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jonafato svsdep maxeaubrey ];
    platforms = platforms.linux;
  };
}
