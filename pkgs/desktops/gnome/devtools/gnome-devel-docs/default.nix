{ lib, stdenv, fetchurl, gnome, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-devel-docs";
  version = "40.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-devel-docs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "v+jyHcqx70sRVlThchK8sDtqEAgzQIA/SW8ia0oILPY=";
  };

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-devel-docs"; attrPath = "gnome.gnome-devel-docs"; };
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
