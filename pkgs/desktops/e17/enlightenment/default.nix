{ stdenv, fetchurl, pkgconfig, eina, eet, evas, ecore, edje, efreet, e_dbus
, embryo, eio, xcbutilkeysyms, libjpeg }:
stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.17.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "1z2vx9r7yc55rs673jg7d685slgdv9dss45asg50wh5wxp2mfi3y";
  };
  buildInputs = [ pkgconfig eina eet ecore evas edje efreet e_dbus embryo
                  eio xcbutilkeysyms libjpeg ];
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
