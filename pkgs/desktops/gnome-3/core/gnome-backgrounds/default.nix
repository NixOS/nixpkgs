{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1s5krdmd3md44p1fgr2lqm5ifxb8s1vzx6hm11sb4cgzr4dw6lrz";
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
