{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pciutils-2.2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/software/utils/pciutils/pciutils-2.2.1.tar.bz2;
    md5 = "483a08dc864ec42497ad95310bb1a8ee";
  };
  patches = [./pciutils-path.patch ./pciutils-devicetype.patch];
}
