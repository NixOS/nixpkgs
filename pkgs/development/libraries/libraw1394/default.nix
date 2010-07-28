{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libraw1394-1.3.0";

  src = fetchurl {
    url = "${meta.homepage}/dl/${name}.tar.gz";
    sha256 = "035mrca9fhg4kq8r1s5yjgzg3vrn1nc3ndy13yg3chhqgx4dzzr0";
  };

  meta = { 
    description = "Library providing direct access to the IEEE 1394 bus through the Linux 1394 subsystem's raw1394 user space interface";
    homepage = http://www.linux1394.org;
    license = ["GPL" "LGPL"];
  };
}
