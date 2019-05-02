{ stdenv, fetchFromGitHub, glib, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-topicons-plus-${version}";
  version = "22";

  src = fetchFromGitHub {
    owner = "phocean";
    repo = "TopIcons-plus";
    rev = "v${version}";
    sha256 = "196s1gdir52gbc444pzrb5l7gn5xr5vqk5ajqaiqryqlmp3i8vil";
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
