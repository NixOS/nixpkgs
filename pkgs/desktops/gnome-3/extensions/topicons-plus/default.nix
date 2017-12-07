{ stdenv, fetchFromGitHub, glib, gettext, bash }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-topicons-plus-${version}";
  version = "20";

  src = fetchFromGitHub {
    owner = "phocean";
    repo = "TopIcons-plus";
    rev = "01535328bd43ecb3f2c71376de6fc8d1d8a88577";
    sha256 = "0pwpg72ihgj2jl9pg63y0hibdsl27srr3mab881w0gh17vwyixzi";
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
