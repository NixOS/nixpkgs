{ stdenv, fetchurl, pkgconfig, gnome3, itstool, libxml2, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-user-docs-${version}";
  version = "3.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0gg1rgg15lbgjdwpwlqazfjv8sm524ys024qsd4n09jlgx21jscd";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-user-docs"; attrPath = "gnome3.gnome-user-docs"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnome3.yelp itstool libxml2 intltool ];

  meta = with stdenv.lib; {
    homepage = "https://help.gnome.org/users/gnome-help/${gnome3.version}";
    description = "User and system administration help for the GNOME desktop";
    maintainers = gnome3.maintainers;
    license = licenses.cc-by-30;
    platforms = platforms.linux;
  };
}
