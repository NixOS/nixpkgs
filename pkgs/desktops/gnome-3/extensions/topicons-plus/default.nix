{ lib, stdenv, fetchFromGitHub, glib, gnome3, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-topicons-plus";
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

  uuid = "TopIcons@phocean.net";

  meta = with lib; {
    description = "Brings all icons back to the top panel, so that it's easier to keep track of apps running in the backround";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = "https://github.com/phocean/TopIcons-plus";
    # Unmaintained and no longer working with GNOME Shell 3.34+
    broken = lib.versionAtLeast gnome3.gnome-shell.version "3.32";
  };
}
