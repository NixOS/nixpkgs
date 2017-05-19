{ stdenv, fetchurl, vala_0_32, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, makeWrapper }:

let
  majorVersion = "0.26";
in
stdenv.mkDerivation rec {
  name = "dconf-${version}";
  version = "${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/${majorVersion}/${name}.tar.xz";
    sha256 = "1jaqsr1r0grpd25rbsc2v3vb0sc51lia9w31wlqswgqsncp2k0w6";
  };

  outputs = [ "out" "lib" "dev" ];

  buildInputs = [ vala_0_32 libxslt pkgconfig glib dbus_glib gnome3.gtk libxml2
                  intltool docbook_xsl docbook_xsl_ns makeWrapper ];

  postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace client/Makefile \
      --replace "-soname=libdconf.so.1" "-install_name,libdconf.so.1"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = gnome3.maintainers;
  };
}
