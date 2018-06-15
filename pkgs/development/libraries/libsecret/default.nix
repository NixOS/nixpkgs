{ stdenv, fetchurl, glib, pkgconfig, intltool, libxslt, docbook_xsl, gtk-doc
, libgcrypt, gobjectIntrospection, vala_0_38, gnome3, libintl }:
let
  pname = "libsecret";
  version = "0.18.5";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1cychxc3ff8fp857iikw0n2s13s2mhw2dn1mr632f7w3sn6vvrww";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig intltool libxslt docbook_xsl libintl ];
  buildInputs = [ libgcrypt gobjectIntrospection vala_0_38 ];
  # optional: build docs with gtk-doc? (probably needs a flag as well)

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "A library for storing and retrieving passwords and other secrets";
    homepage = https://wiki.gnome.org/Projects/Libsecret;
    license = stdenv.lib.licenses.lgpl21Plus;
    inherit (glib.meta) platforms maintainers;
  };
}
