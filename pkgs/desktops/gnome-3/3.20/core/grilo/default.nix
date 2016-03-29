{ stdenv, fetchurl, pkgconfig, file, intltool, glib
, libxml2, gnome3, gobjectIntrospection, libsoup }:

stdenv.mkDerivation rec {
  name = "grilo-0.2.12";

  src = fetchurl {
    url = "mirror://gnome/sources/grilo/0.2/${name}.tar.xz";
    sha256 = "11bvc7rsrjjwz8hp67p3fn8zmywrpawrcbi3vgw8b0dwa0sndd2m";
  };

  setupHook = ./setup-hook.sh;

  configureFlags = [ "--enable-grl-pls" "--enable-grl-net" ];

  preConfigure = ''
    for f in src/Makefile.in libs/pls/Makefile.in libs/net/Makefile.in; do
       substituteInPlace $f --replace @INTROSPECTION_GIRDIR@ "$out/share/gir-1.0/"
       substituteInPlace $f --replace @INTROSPECTION_TYPELIBDIR@ "$out/lib/girepository-1.0"
    done
  '';

  buildInputs = [ pkgconfig file intltool glib libxml2 libsoup
                  gnome3.totem-pl-parser gobjectIntrospection ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Grilo;
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
