args: with args;
stdenv.mkDerivation {
  name = "liblo";

  src = fetchurl {
    url = mirror://sourceforge/liblo/liblo/0.26/liblo-0.26.tar.gz;
    sha256 = "0n124fv9m8yjxs2yxnp3l1i30b8qgg1zx51y63ax12hpz04zndm6";
  };

  buildInputs = [];

  meta = { 
    description = "lightweight library to handle the sending and receiving of messages according to the Open Sound Control (OSC) protocol";
    homepage = http://sourceforge.net/projects/liblo;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
