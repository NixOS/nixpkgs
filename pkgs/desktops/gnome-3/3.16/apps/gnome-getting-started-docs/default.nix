{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-getting-started-docs-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-getting-started-docs/${gnome3.version}/${name}.tar.xz";
    sha256 = "07wz35r6p9nvlshwcyjvhjnzbaw3bzadlhwz51c8nky7m7pdgmyy";
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://live.gnome.org/DocumentationProject;
    description = "Help a new user get started in GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
  };
}
