{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection
  # just for passthru
, gnome3, gtk3, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {

  versionMajor = gnome3.version;
  versionMinor = "1";
  moduleName   = "gsettings-desktop-schemas";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "0q9l9fr90pcb3s6crbxkj3wiwn7wp9zfpv7bdxkadj0hspd9zzkl";
  };

  buildInputs = [ glib gobjectIntrospection ];

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    maintainers = [ maintainers.lethalman ];
  };
}
