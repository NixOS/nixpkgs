{stdenv, fetchurl, python, pkgconfig, libxml2, libxslt, intltool, scrollkeeper}:

stdenv.mkDerivation {
  name = "gnome-doc-utils-0.16.1";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/gnome-doc-utils-0.16.1.tar.bz2;
    sha256 = "0j722qk8drib65abbjsva0cq25wzq7adag9m7hxjpi7wdvqcgq3k";
  };
  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ python pkgconfig libxml2 libxslt intltool scrollkeeper ];
}
