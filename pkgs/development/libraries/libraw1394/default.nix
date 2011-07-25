{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libraw1394-2.0.7";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/ieee1394/${name}.tar.gz";
    sha256 = "1mq9yy73q85lzk288lbdzvzrs5ajh84pzfh7xdhd3d8dy9v53xca";
  };

  meta = { 
    description = "Library providing direct access to the IEEE 1394 bus through the Linux 1394 subsystem's raw1394 user space interface";
    homepage = "https://ieee1394.wiki.kernel.org/index.php/Libraries#libraw1394";
    license = ["GPL" "LGPL"];
  };
}
