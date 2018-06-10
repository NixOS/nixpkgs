{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-getting-started-docs-${version}";
  version = "3.28.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-getting-started-docs/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0vg0b4nr7azj6p5cpd7h7ya5hw6q89gnzig8hvp6swwrwg2p5nif";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-getting-started-docs"; attrPath = "gnome3.gnome-getting-started-docs"; };
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
