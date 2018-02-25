{ stdenv, fetchurl, pkgconfig, file, intltool, glib, sqlite
, gnome3, libxml2, gupnp, gssdp, lua5, liboauth, gupnp-av
, gmime, json-glib, avahi, tracker, dleyna-server, itstool }:

stdenv.mkDerivation rec {
  major = "0.3";
  minor = "5";
  name = "grilo-plugins-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/grilo-plugins/${major}/${name}.tar.xz";
    sha256 = "1yv8a0mfd5qmdbdrnd0is5c51s1mvibhw61na99iagnbirxq4xr9";
  };

  installFlags = [ "GRL_PLUGINS_DIR=$(out)/lib/grilo-${major}" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnome3.grilo libxml2 gupnp gssdp gnome3.libgdata
                  lua5 liboauth gupnp-av sqlite gnome3.gnome-online-accounts
                  gnome3.totem-pl-parser gnome3.rest gmime json-glib
                  avahi gnome3.libmediaart tracker dleyna-server intltool itstool ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Grilo;
    description = "A collection of plugins for the Grilo framework";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
