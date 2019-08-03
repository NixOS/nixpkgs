{ stdenv, fetchurl, pkgconfig, gtkmm3, glibmm, gtksourceview4, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gtksourceviewmm";
  version = "3.91.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "088p2ch1b4fvzl9416nw3waj0pqgp31cd5zj4lx5hzzrq2afgapy";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glibmm gtkmm3 gtksourceview4 ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://developer.gnome.org/gtksourceviewmm/;
    description = "C++ wrapper for gtksourceview";
    license = licenses.lgpl2;
    maintainers = gnome3.maintainers;
  };
}

