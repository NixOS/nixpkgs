{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-devel-docs-${version}";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-devel-docs/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0xqpgf975rws60qxilq635pblbpgwspyykgzxnb4awd9zrs5lbx0";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-devel-docs"; attrPath = "gnome3.gnome-devel-docs"; };
  };

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/GNOME/gnome-devel-docs;
    description = "Developer documentation for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.fdl12;
    platforms = platforms.linux;
  };
}
