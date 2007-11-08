{stdenv, fetchurl, libgcrypt}:

stdenv.mkDerivation {
  name = "gnutls-1.1.23";
  
  src = fetchurl {
    url = http://www.gnu.org/software/gnutls/releases/gnutls-1.1.23.tar.bz2;
    sha256 = "0p5565rrinh1ajyphl9mljr3143mzall48vs02n3y03pv8srh7zh";
  };

  buildInputs = [libgcrypt];
  
  meta = {
    description = "The GNU Transport Layer Security Library";
    homepage = http://www.gnu.org/software/gnutls/;
    license = "LGPL";
  };
}
