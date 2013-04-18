{stdenv, fetchurl, pkgconfig, libxml2, glib}:

stdenv.mkDerivation rec {
  name = "libcroco-0.6.6"; # 3.6.2 release

  src = fetchurl {
    url = "mirror://gnome/sources/libcroco/0.6/${name}.tar.xz";
    sha256 = "1nbb12420v1zacn6jwa1x4ixikkcqw66sg4j5dgs45nhygiarv3j";
  };
  buildInputs = [ pkgconfig libxml2 glib ];
}
