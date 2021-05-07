{ lib, stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-devel-docs";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-devel-docs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "0zqp01ks8m3s6jn5xqd05rw4fwbvxy5qvcfg9g50b2ar2j7v1ar8";
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
