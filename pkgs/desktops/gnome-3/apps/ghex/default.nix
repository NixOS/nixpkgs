{ stdenv, fetchurl, pkgconfig, gnome3, intltool, itstool, libxml2, gtk3,
  wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "ghex-${version}";
  version = "3.18.3";

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "c67450f86f9c09c20768f1af36c11a66faf460ea00fbba628a9089a6804808d3";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ gtk3 intltool itstool libxml2 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "ghex";
      attrPath = "gnome3.ghex";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Ghex;
    description = "Hex editor for GNOME desktop environment";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
