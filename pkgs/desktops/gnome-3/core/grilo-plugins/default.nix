{ stdenv, fetchurl, pkgconfig, intltool, sqlite
, gnome3, libxml2, gupnp, gssdp, lua5, liboauth, gupnp-av
, gmime, json-glib, avahi, tracker, dleyna-server, itstool }:

let
  pname = "grilo-plugins";
  version = "0.3.7";
  major = stdenv.lib.versions.majorMinor version;
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${major}/${name}.tar.xz";
    sha256 = "0838mm7sdfwsiw022rjb27dlbbxncpx5jrpv3qzfadli66y3nbzw";
  };

  installFlags = [ "GRL_PLUGINS_DIR=$(out)/lib/grilo-${major}" ];

  nativeBuildInputs = [ pkgconfig intltool itstool ];
  buildInputs = [
    gnome3.grilo libxml2 gupnp gssdp gnome3.libgdata
    lua5 liboauth gupnp-av sqlite gnome3.gnome-online-accounts
    gnome3.totem-pl-parser gnome3.rest gmime json-glib
    avahi gnome3.libmediaart tracker dleyna-server
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Grilo;
    description = "A collection of plugins for the Grilo framework";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
