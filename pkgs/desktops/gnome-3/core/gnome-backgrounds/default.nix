{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-backgrounds";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0zxlwy55fz7i582hch2wnj8zy1kzikssgaix0l2y41ccp5nzpdy2";
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
