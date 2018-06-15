{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1qgim0yhzjgcq172y4vp5hqz4rh1ak38a7pgi6s7dq0wklyrcnxj";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-backgrounds"; attrPath = "gnome3.gnome-backgrounds"; };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
