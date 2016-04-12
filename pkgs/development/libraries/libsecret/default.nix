{ stdenv, fetchurl, glib, pkgconfig, intltool, libxslt, docbook_xsl, gtk_doc
, libgcrypt, gobjectIntrospection }:
let
  version = "0.18.5";
in
stdenv.mkDerivation rec {
  name = "libsecret-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsecret/0.18/${name}.tar.xz";
    sha256 = "1cychxc3ff8fp857iikw0n2s13s2mhw2dn1mr632f7w3sn6vvrww";
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
