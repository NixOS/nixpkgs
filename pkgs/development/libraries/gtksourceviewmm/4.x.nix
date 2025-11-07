{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtkmm3,
  glibmm,
  gtksourceview4,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gtksourceviewmm";
  version = "3.91.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "088p2ch1b4fvzl9416nw3waj0pqgp31cd5zj4lx5hzzrq2afgapy";
  };

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gtksourceviewmm4";
      packageName = "gtksourceviewmm";
      versionPolicy = "none";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    glibmm
    gtkmm3
    gtksourceview4
  ];

  meta = with lib; {
    platforms = platforms.linux;
    homepage = "https://gitlab.gnome.org/GNOME/gtksourceviewmm";
    description = "C++ wrapper for gtksourceview";
    license = licenses.lgpl2;
    teams = [ teams.gnome ];
  };
}
