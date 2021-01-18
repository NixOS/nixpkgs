{ lib, stdenv, fetchurl, meson, ninja, pkg-config, gnome3, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-backgrounds";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1qqygm15rcdgm36vz2iy7b9axndjzvpi29lmygyakjc07a3jlwgp";
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
