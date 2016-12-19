{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libraw1394-2.1.1";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/ieee1394/${name}.tar.gz";
    sha256 = "0x6az154wr7wv3945485grjvpk604khv34dbaph6vmc1zdasqq59";
  };

  meta = with stdenv.lib; {
    description = "Library providing direct access to the IEEE 1394 bus through the Linux 1394 subsystem's raw1394 user space interface";
    homepage = "https://ieee1394.wiki.kernel.org/index.php/Libraries#libraw1394";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
