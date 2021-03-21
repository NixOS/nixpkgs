{ lib, stdenv, fetchurl, meson, ninja, pkg-config, gnome3, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-backgrounds";
  version = "40.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "0yd6zlv37bx7wsl19bil00ngpyxyk1rh5kihs35cb3vyy75xla4d";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-backgrounds"; attrPath = "gnome3.gnome-backgrounds"; };
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext ];

  meta = with lib; {
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
