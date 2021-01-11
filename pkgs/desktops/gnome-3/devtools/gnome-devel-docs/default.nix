{ lib, stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-devel-docs";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-devel-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1h6481hbz1c5p69r6h96hbgf560lhp1jibszscgw0s2yikdh6q8n";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-devel-docs"; attrPath = "gnome3.gnome-devel-docs"; };
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with lib; {
    homepage = "https://github.com/GNOME/gnome-devel-docs";
    description = "Developer documentation for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.fdl12;
    platforms = platforms.linux;
  };
}
