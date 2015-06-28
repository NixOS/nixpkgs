{ stdenv, fetchurl, pciutils }:

stdenv.mkDerivation rec {
  name = "gnu-efi-${version}";
  version = "3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${name}.tar.bz2";
    sha256 = "1mxl6xarwickhssn0nc5hyvayyf2cjh5p10l37jd1ymirl75hjqr";
  };

  buildInputs = [ pciutils ];

  makeFlags = [
    "PREFIX=\${out}"
    "CC=gcc"
    "AS=as"
    "LD=ld"
    "AR=ar"
    "RANLIB=ranlib"
    "OBJCOPY=objcopy"
  ];

  meta = with stdenv.lib; {
    description = "GNU EFI development toolchain";
    homepage = http://sourceforge.net/projects/gnu-efi/;
    license = licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = platforms.linux;
  };
}
