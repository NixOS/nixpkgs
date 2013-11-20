{ stdenv, fetchurl, pkgconfig, gobjectIntrospection, lua, glib }:

stdenv.mkDerivation {
  name = "lgi-0.7.2";

  src = fetchurl {
    url    = https://github.com/pavouk/lgi/archive/0.7.2.tar.gz;
    sha256 = "0ihl7gg77b042vsfh0k7l53b7sl3d7mmrq8ns5lrsf71dzrr19bn";
  };

  meta = with stdenv.lib; {
    description = "Gobject-introspection based dynamic Lua binding to GObject based libraries";
    homepage    = https://github.com/pavouk/lgi;
    license     = "custom";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

  buildInputs = [ glib gobjectIntrospection lua pkgconfig ];

  preBuild = ''
    sed -i "s|/usr/local|$out|" lgi/Makefile
  '';
}
