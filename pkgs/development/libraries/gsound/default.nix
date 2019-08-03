{ stdenv, fetchurl, pkgconfig, glib, libcanberra, gobject-introspection, libtool, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gsound";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bba8ff30eea815037e53bee727bbd5f0b6a2e74d452a7711b819a7c444e78e53";
  };

  nativeBuildInputs = [ pkgconfig gobject-introspection libtool gnome3.vala ];
  buildInputs = [ glib libcanberra ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GSound;
    description = "Small library for playing system sounds";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
