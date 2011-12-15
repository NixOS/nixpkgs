{ stdenv, fetchurl, pkgconfig, eina, eet, evas, ecore, edje, efreet, e_dbus, embryo }:
stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.16.999.65643";
  src = fetchurl {
    url = "http://download.enlightenment.org/snapshots/2011-11-28/${name}.tar.gz";
    sha256 = "1bb577gbccb1wrifrhv9pzm451zhig2p29mwz55b187ls31p36kz";
  };
  buildInputs = [ pkgconfig eina eet ecore evas edje efreet e_dbus embryo ];
  configureFlags = ''
    --with-profile=FAST_PC
    --disable-illume
    --disable-illume2
  '';
  meta = {
    description = "Enlightenment, the window manager";
    longDescription = ''
      The Enlightenment Desktop shell provides an efficient yet
      breathtaking window manager based on the Enlightenment
      Foundation Libraries along with other essential desktop
      components like a file manager, desktop icons and widgets.

      It boasts a un-precedented level of theme-ability while still
      being capable of performing on older hardware or embedded
      devices.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
