{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "liblo-0.26";

  src = fetchurl {
    url = "mirror://sourceforge/liblo/liblo/0.26/${name}.tar.gz";
    sha256 = "0n124fv9m8yjxs2yxnp3l1i30b8qgg1zx51y63ax12hpz04zndm6";
  };

  meta = { 
    description = "Lightweight library to handle the sending and receiving of messages according to the Open Sound Control (OSC) protocol";
    homepage = http://sourceforge.net/projects/liblo;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
