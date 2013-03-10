{ stdenv, fetchurl, yacc, flex, pkgconfig, glib, dbus, dbus_tools }:

stdenv.mkDerivation rec {
  p_name  = "vala";
  ver_maj = "0.19";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://gnome/sources/${p_name}/${ver_maj}/${name}.tar.xz";
    sha256 = "1vn524hcnaggz8zx49mvf7p4z1mscrlj2syg7jjhph8nak5wi0bp";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  postPatch = "patchShebangs .";

  nativeBuildInputs = [ yacc flex pkgconfig ];

  buildInputs = [ glib ] ++ stdenv.lib.optional doCheck [ dbus dbus_tools ];

  doCheck = false; # problems when launching dbus tests

  meta = {
    description = "Compiler for the GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = "free-copyleft";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
