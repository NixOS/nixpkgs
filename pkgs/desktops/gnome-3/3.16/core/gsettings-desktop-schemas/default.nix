{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection
  # just for passthru
, gnome3, gtk3, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {

  versionMajor = gnome3.version;
  versionMinor = "0";
  moduleName   = "gsettings-desktop-schemas";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "02dp1hl38k16m9abydfca1n236mdazqdz0p3n92s7haf9mdqsf16";
  };

  buildInputs = [ glib gobjectIntrospection ];

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    maintainers = [ maintainers.lethalman ];
  };
}
