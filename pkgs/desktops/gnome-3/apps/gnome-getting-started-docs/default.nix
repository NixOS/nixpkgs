{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-getting-started-docs-${version}";
  version = "3.31.91";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-getting-started-docs/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0vc4ywgnm003aqkm5xrrh6bpz1y8xhk3cva1rnarzhcchq9xagg6";
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
