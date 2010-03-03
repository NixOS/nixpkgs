{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libv4l-0.6.2";
  src = fetchurl {
    url = http://people.atrpms.net/~hdegoede/libv4l-0.6.1.tar.gz;
    sha256 = "1grbyb9vsdlp6yx4inmazgp5g0jxga8wbl3h8dv6vlfh5hckxf9n";
  };
  installPhase = "make PREFIX=$out install";
}
