{ stdenv, fetchurl, pkgconfig, ecore, eina, evas, dbus_libs }:
stdenv.mkDerivation rec {
  name = "e_dbus-${version}";
  version = "1.0.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "1ifkijy4ap2mlqw2nd1dlvzlppyi7bnp15bxiy40nhdly8vhpbdl";
  };
  buildInputs = [ pkgconfig ecore eina evas ];
  propagatedBuildInputs = [ dbus_libs ];
  configureFlags = ''
    --disable-edbus-test
    --disable-edbus-test-client
    --disable-edbus-notify-send
    --disable-edbus-notify-test
  '';
  meta = {
    description = "Enlightenment's D-Bus wrapping and glue layer library";
    longDescription = ''
      Enlightenment's E_Dbus is a set of wrappers around DBus APIs by
      third party, so they can be easily used by EFL applications,
      automatically providing Ecore/main loop integration, as well as
      Eina data types.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
