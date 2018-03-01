{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus-glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, makeWrapper }:

let
  majorVersion = "0.26";
in
stdenv.mkDerivation rec {
  name = "dconf-${version}";
  version = "${majorVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/${majorVersion}/${name}.tar.xz";
    sha256 = "0da587hpiqy8h3pswn1102h4b905x8k6mk3ajpi7kf4kzkvv30ym";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ vala pkgconfig intltool libxslt libxml2 docbook_xsl docbook_xsl_ns makeWrapper ];
  buildInputs = [ glib dbus-glib ];

  postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace client/Makefile \
      --replace "-soname=libdconf.so.1" "-install_name,libdconf.so.1"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = gnome3.maintainers;
  };
}
