{ stdenv, fetchFromGitHub, glib, gettext, bash }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-topicons-plus-${version}";
  version = "21";

  src = fetchFromGitHub {
    owner = "phocean";
    repo = "TopIcons-plus";
    rev = "v${version}";
    sha256 = "15p61krd7lcmgr1d4s2ydfjy3pyq79pq5100xzy6dln1538901m3";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [ gettext ];

  makeFlags = [ "INSTALL_PATH=$(out)/share/gnome-shell/extensions" ];

  meta = with stdenv.lib; {
    description = "Brings all icons back to the top panel, so that it's easier to keep track of apps running in the backround";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = https://github.com/phocean/TopIcons-plus;
  };
}
