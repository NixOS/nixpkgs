args: with args;

stdenv.mkDerivation {
  name = "gtkmm-2.12.7";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.12/gtkmm-2.12.7.tar.bz2;
    sha256 = "1syrn4ppjd0an4ly6vmi388q6aav5fakj39wbcvs4nbphanwjn2f";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glibmm gtk atk cairomm];
}

