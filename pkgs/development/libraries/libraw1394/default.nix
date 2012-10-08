{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libraw1394-2.1.0";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/ieee1394/${name}.tar.gz";
    sha256 = "0w5sw06p51wfq2ahgql93ljkkp3hqprifzcxq8dq71c8zcbgyg58";
  };

  meta = { 
    description = "Library providing direct access to the IEEE 1394 bus through the Linux 1394 subsystem's raw1394 user space interface";
    homepage = "https://ieee1394.wiki.kernel.org/index.php/Libraries#libraw1394";
    license = ["GPL" "LGPL"];
  };
}
