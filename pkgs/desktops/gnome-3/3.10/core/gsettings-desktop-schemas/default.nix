{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection
  # just for passthru
, gtk3, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {

  versionMajor = "3.10";
  versionMinor = "1";
  moduleName   = "gsettings-desktop-schemas";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "04b8wy10l6pzs5928gnzaia73dz5fjlcdy39xi3mf50ajv27h8s5";
  };

  buildInputs = [ glib gobjectIntrospection ];

  nativeBuildInputs = [ pkgconfig intltool ];

  passthru = {
    doCompileSchemas = ''
      for pkg in "${gsettings_desktop_schemas}" "${gtk3}"; do
        cp -s $pkg/share/glib-2.0/schemas/*.gschema.xml $out/share/glib-2.0/schemas/
      done
      ${glib}/bin/glib-compile-schemas $out/share/glib-2.0/schemas/
    '';
  };
}
