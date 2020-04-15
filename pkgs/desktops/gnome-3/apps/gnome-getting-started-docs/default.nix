{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-getting-started-docs";
  version = "3.36.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-getting-started-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "09bf9r6brmll14z87ljgivw0nr0nggcgjpbx6lg2835zq36vfmi9";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-getting-started-docs"; attrPath = "gnome3.gnome-getting-started-docs"; };
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = "https://live.gnome.org/DocumentationProject";
    description = "Help a new user get started in GNOME";
    maintainers = teams.gnome.members;
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
  };
}
