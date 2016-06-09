{ stdenv, fetchurl, pkgconfig, file, intltool, glib, sqlite
, gnome3, libxml2, gupnp, gssdp, lua5, liboauth, gupnp_av
, gmime, json_glib, avahi, tracker, itstool }:

stdenv.mkDerivation rec {
  major = "0.3";
  minor = "1";
  name = "grilo-plugins-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/grilo-plugins/${major}/${name}.tar.xz";
    sha256 = "1akd7q6pqnkcnayrdfjb0qx5w5yyl06kxzwhqp2gxm4y1b208pb0";
  };

  installFlags = [ "GRL_PLUGINS_DIR=$(out)/lib/grilo-${major}" ];

  buildInputs = [ pkgconfig gnome3.grilo libxml2 gupnp gssdp gnome3.libgdata
                  lua5 liboauth gupnp_av sqlite gnome3.gnome_online_accounts
                  gnome3.totem-pl-parser gnome3.rest gmime json_glib
                  avahi gnome3.libmediaart tracker intltool itstool ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Grilo;
    description = "A collection of plugins for the Grilo framework";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
