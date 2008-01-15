args:
args.stdenv.mkDerivation {
  name = "libraw1394-1.2.0";

  src = args.fetchurl {
    url = "mirror://sourceforge/libraw1394/libraw1394-1.2.0.tar.gz";
    sha256 = "1b9zqqzyz0ihyfvhn135y3wc6vmym5yz21jxj9dp0f09b96gmp0z";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "library providing direct access to the IEEE 1394 bus through the Linux 1394 subsystem's raw1394 user space interface";
      homepage = "http://wiki.linux1394.org/";
      license = ["GPL" "LGPL"];
  };
}
