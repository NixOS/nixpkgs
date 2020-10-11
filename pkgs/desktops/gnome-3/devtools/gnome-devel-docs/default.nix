{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-devel-docs";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-devel-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "07849yhpc4l4jscskpsbjwsp5qs8f0jz3rmh3p1nj13vxmvgm5j5";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-devel-docs"; attrPath = "gnome3.gnome-devel-docs"; };
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/GNOME/gnome-devel-docs";
    description = "Developer documentation for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.fdl12;
    platforms = platforms.linux;
  };
}
