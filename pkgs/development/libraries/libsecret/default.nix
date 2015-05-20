{ stdenv, fetchurl, glib, pkgconfig, intltool, libxslt, docbook_xsl, gtk_doc
, libgcrypt, gobjectIntrospection }:
let
  version = "0.18";
in
stdenv.mkDerivation rec {
  name = "libsecret-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsecret/${version}/${name}.tar.xz";
    sha256 = "1qq29c01xxjyx5sl6y5h22w8r0ff4c73bph3gfx3h7mx5mvalwqc";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig intltool libxslt docbook_xsl ];
  buildInputs = [ libgcrypt gobjectIntrospection ];
  # optional: build docs with gtk-doc? (probably needs a flag as well)

  meta = {
    description = "A library for storing and retrieving passwords and other secrets";
    homepage = https://wiki.gnome.org/Projects/Libsecret;
    license = stdenv.lib.licenses.lgpl21Plus;
    inherit (glib.meta) platforms maintainers;
  };
}
