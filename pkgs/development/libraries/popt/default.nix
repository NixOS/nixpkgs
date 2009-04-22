{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "popt-1.15";
  
  src = fetchurl {
    url = http://rpm5.org/files/popt/popt-1.15.tar.gz;
    sha256 = "1wqbcimg4zlfp7261i89s1918a46fjfbvq1a4ij4a6prk27576q6";
  };
}
