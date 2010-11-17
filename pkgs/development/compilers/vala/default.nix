{stdenv, fetchurl, yacc, flex, pkgconfig, glib}:

stdenv.mkDerivation rec {
  baseName = "vala";
  baseVersion = "0.11";
  revision = "2";
  version = "${baseVersion}.${revision}";
  name = "${baseName}-${version}";
  src = fetchurl {
    url = "mirror://gnome/sources/${baseName}/${baseVersion}/${name}.tar.bz2";
    sha256 = "489b60a49a03c8915b513a722ca08986c18ae0dc6489cce6bbb8415670612046";
  };
  buildInputs = [ yacc flex glib pkgconfig ];
  meta = {
    description = "Compiler for the GObject type system";
    homepage = "http://live.gnome.org/Vala";
  };
}
