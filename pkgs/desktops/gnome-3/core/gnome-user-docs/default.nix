{ stdenv, fetchurl, pkgconfig, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  pname = "gnome-user-docs";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1v94mz8zwzx67db2avbi9p2klw36cz45qr6fbskpvygz2pzhg6cg";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-user-docs"; attrPath = "gnome3.gnome-user-docs"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnome3.yelp itstool libxml2 intltool ];

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-help/;
    description = "User and system administration help for the GNOME desktop";
    maintainers = gnome3.maintainers;
    license = licenses.cc-by-30;
    platforms = platforms.linux;
  };
}
