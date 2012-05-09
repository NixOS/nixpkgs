{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libraw1394-2.0.8";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/ieee1394/${name}.tar.gz";
    sha256 = "0cwd8xn7wsm7nddbz7xgynxcjb1m4v2vjw1ky4dd6r5cv454hslk";
  };

  meta = { 
    description = "Library providing direct access to the IEEE 1394 bus through the Linux 1394 subsystem's raw1394 user space interface";
    homepage = "https://ieee1394.wiki.kernel.org/index.php/Libraries#libraw1394";
    license = ["GPL" "LGPL"];
  };
}
