{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, gnome3, intltool }:

stdenv.mkDerivation rec {
  pname = "gdl";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "00ldva6wg6s4wlxmisiqzyz8ihsprra7sninx2rlqk6frpq312w5";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ libxml2 gtk3 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gdl";
    };
  };

  meta = with stdenv.lib; {
    description = "Gnome docking library";
    homepage = https://developer.gnome.org/gdl/;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
