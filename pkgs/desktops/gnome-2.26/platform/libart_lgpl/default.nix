{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libart_lgpl-2.3.20";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/libart_lgpl-2.3.20.tar.bz2;
    sha256 = "0iyqsc517lj8xnidchnk0fxa6aqvss4hv8p9fk6bba86lbiillym";
  };
}
