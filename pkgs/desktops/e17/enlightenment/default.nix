{ stdenv, fetchurl, pkgconfig, eina, eet, evas, ecore, edje, efreet, e_dbus }:
stdenv.mkDerivation rec {
  name = "enlightenment-0.16.999.55225";
  src = fetchurl {
    url = "http://download.enlightenment.org/snapshots/2010-12-03/${name}.tar.gz";
    sha256 = "1cv701fidp9mx3g5m9klmzsp0fj149rb133v1w76rzms3a0wljl1";
  };
  buildInputs = [ pkgconfig eina eet ecore evas edje efreet e_dbus ];
  configureFlags = "--with-profile=FAST_PC";
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
