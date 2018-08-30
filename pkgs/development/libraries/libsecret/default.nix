{ stdenv, fetchurl, glib, pkgconfig, intltool, libxslt, docbook_xsl
, libgcrypt, gobjectIntrospection, vala_0_38, gnome3, libintl }:

stdenv.mkDerivation rec {
  pname = "libsecret";
  version = "0.18.5";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1cychxc3ff8fp857iikw0n2s13s2mhw2dn1mr632f7w3sn6vvrww";
  };

  postPatch = ''
    patchShebangs .
  '';

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig intltool libxslt docbook_xsl libintl ];
  buildInputs = [ libgcrypt gobjectIntrospection vala_0_38 ];
  # optional: build docs with gtk-doc? (probably needs a flag as well)

  # checkInputs = [ python2 ];

  doCheck = false; # fails. with python3 tests fail to evaluate, with python2 they fail to run python3

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
