{ stdenv, fetchurl, pkgconfig, intltool, glib
  # just for passthru
, gtk3, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {

  versionMajor = "3.6";
  versionMinor = "1";
  moduleName   = "gsettings-desktop-schemas";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1rk71q2rky9nzy0zb5jsvxa62vhg7dk65kdgdifq8s761797ga6r";
  };

  buildInputs = [ glib ];

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
