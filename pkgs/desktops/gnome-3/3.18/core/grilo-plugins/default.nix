{ stdenv, fetchurl, pkgconfig, file, intltool, glib, sqlite
, gnome3, libxml2, gupnp, gssdp, lua5, liboauth, gupnp_av
, gmime, json_glib, avahi, tracker, itstool }:

stdenv.mkDerivation rec {
  name = "grilo-plugins-0.2.16";

  src = fetchurl {
    url = "mirror://gnome/sources/grilo-plugins/0.2/${name}.tar.xz";
    sha256 = "00sjmkzxc8w4qn4lp5yj65c4y83mwhp0zlvk11ghvpxnklgmgd40";
  };

  installFlags = [ "GRL_PLUGINS_DIR=$(out)/lib/grilo-0.2" ];

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
