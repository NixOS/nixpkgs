{stdenv, fetchurl, pkgconfig, pcsclite}:
stdenv.mkDerivation {
  name = "libmusclecard-1.3.6";

  src = fetchurl {
    url = https://alioth.debian.org/frs/download.php/3024/libmusclecard-1.3.6.tar.bz2;
    sha256 = "1sswy7vcy0w9p6818al7prv9d3whj7w3w98k55zw9nhspbj6lppb";
  };

  # The OS should care on preparing the services into this location
  configureFlags = [ "--enable-muscledropdir=/var/lib/pcsc/services" ];

  buildInputs = [ pkgconfig pcsclite ];

  meta = {
    description = "Library for MUSCLE smartcard applications";
    homepage = http://pcsclite.alioth.debian.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = true;
  };
}
