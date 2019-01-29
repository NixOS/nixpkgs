{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, sqlite
, gnome3, libxml2, gupnp, gssdp, lua5, liboauth, gupnp-av
, gmime, json-glib, avahi, tracker, dleyna-server, itstool, totem-pl-parser }:

let
  pname = "grilo-plugins";
  version = "0.3.8";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0nync07gah3jkpb5ph5d3gwbygmabnih2m3hfz7lkvjl2l5pgpac";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool ];
  buildInputs = [
    gnome3.grilo libxml2 gupnp gssdp gnome3.libgdata
    lua5 liboauth gupnp-av sqlite gnome3.gnome-online-accounts
    totem-pl-parser gnome3.rest gmime json-glib
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
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
