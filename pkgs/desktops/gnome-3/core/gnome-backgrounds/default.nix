{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gettext }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-${version}";
  version = "3.31.91";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "15ca2510d8f4w6lpg0pw4m62fn1dg909ngrx70nmjpqsxiwmiz11";
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
