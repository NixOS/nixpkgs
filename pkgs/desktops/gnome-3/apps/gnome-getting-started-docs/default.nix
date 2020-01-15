{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "gnome-getting-started-docs";
  version = "3.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-getting-started-docs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1v4k465mlzrhgcdddzs6bmm0yliyrfx6jg3gh0s17a08i0w5rbwq";
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
