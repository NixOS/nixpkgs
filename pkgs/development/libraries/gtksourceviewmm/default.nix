{ lib, stdenv, fetchurl, pkg-config, gtkmm3, glibmm, gtksourceview3, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gtksourceviewmm";
  version = "3.91.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceviewmm/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "088p2ch1b4fvzl9416nw3waj0pqgp31cd5zj4lx5hzzrq2afgapy";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtksourceviewmm";
      versionPolicy = "none";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glibmm gtkmm3 gtksourceview3 ];

  meta = with lib; {
    platforms = platforms.linux;
    homepage = "https://developer.gnome.org/gtksourceviewmm/";
    description = "C++ wrapper for gtksourceview";
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}

