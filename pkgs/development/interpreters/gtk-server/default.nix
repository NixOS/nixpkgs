{ stdenv, fetchurl, libffcall, gtk2, pkgconfig }:

stdenv.mkDerivation rec {
  v = "2.3.1";
  name = "gtk-server-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/gtk-server/${name}-sr.tar.gz";
    sha256 = "0z8ng5rhxc7fpsj3d50h25wkgcnxjfy030jm8r9w9m729w2c9hxb";
  };

  buildInputs = [ libffcall gtk2 pkgconfig ];

  configureOptions = [ "--with-gtk2" ];

  meta = {
    description = "gtk-server for interpreted GUI programming";
    homepage = "http://www.gtk-server.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.tohl];
    platforms = stdenv.lib.platforms.linux;
  };
}
