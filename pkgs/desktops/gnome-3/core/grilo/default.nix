{ stdenv, fetchurl, pkgconfig, file, intltool, glib
, libxml2, gnome3, gobjectIntrospection, libsoup, python3Packages }:

stdenv.mkDerivation rec {
  major = "0.3"; # if you change this, also change ./setup-hook.sh
  minor = "3";
  name = "grilo-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/grilo/${major}/${name}.tar.xz";
    sha256 = "1qx072m0gl6m3d5g5cbbf13p4h217icmlxjnrn829x5xqwi451sw";
  };

  setupHook = ./setup-hook.sh;

  configureFlags = [ "--enable-grl-pls" "--enable-grl-net" ];

  preConfigure = ''
    for f in src/Makefile.in libs/pls/Makefile.in libs/net/Makefile.in; do
       substituteInPlace $f --replace @INTROSPECTION_GIRDIR@ "$out/share/gir-1.0/"
       substituteInPlace $f --replace @INTROSPECTION_TYPELIBDIR@ "$out/lib/girepository-1.0"
    done
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ file intltool glib libxml2 libsoup
                  gnome3.totem-pl-parser ];

  propagatedBuildInputs = [ python3Packages.pygobject3 gobjectIntrospection ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Grilo;
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
