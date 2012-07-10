{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python, cairo }:

stdenv.mkDerivation rec {

  versionMajor = "1.33";
  versionMinor = "3";
  moduleName   = "gobject-introspection";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1dziqpas9hg2nkyzy6l53mrjnp2argfszj4cqzdw7ia0zfccmc4q";
  };

  buildInputs = [ flex bison glib pkgconfig python ];
  propagatedBuildInputs = [ libffi ];

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.antono ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };

  configureFlags = [ "--disable-tests" ];
}
