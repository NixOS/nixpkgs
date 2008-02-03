args: with args;

stdenv.mkDerivation {
  name = "gtkmm-2.10.11";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.10/gtkmm-2.10.11.tar.bz2;
    sha256 = "1bri9r0k69dmi5xgzrlfllp3adfzhz8dh9zkcvi6sjkgfwi594vx";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glibmm gtk atk cairomm];
}

