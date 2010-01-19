{stdenv, fetchurl, m4, cxx ? true}:

stdenv.mkDerivation rec {
  name = "gmp-4.3.2";

  src = fetchurl {
    url = "mirror://gnu/gmp/${name}.tar.bz2";
    sha256 = "0x8prpqi9amfcmi7r4zrza609ai9529pjaq0h4aw51i867064qck";
  };

  buildNativeInputs = [m4];

  preConfigure = "ln -sf configfsf.guess config.guess";

  configureFlags = if cxx then "--enable-cxx" else "--disable-cxx";

  doCheck = true;

  meta = {
    description = "A free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers";
    homepage = http://gmplib.org/;
    license = "LGPL";
  };
}
