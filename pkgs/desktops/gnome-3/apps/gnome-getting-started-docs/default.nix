{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-getting-started-docs-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-getting-started-docs/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "34f45f6b5759a46547e834f1b706ae7485fd94e1af5354154420d8910ec67775";
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
