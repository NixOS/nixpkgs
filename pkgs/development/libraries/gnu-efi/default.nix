{ stdenv, buildPackages, fetchurl, fetchpatch, pciutils }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    sha256 = "1w3p4aqlc5j93q44la7dc8cr3hky20zvsd0h0k2lyzhwmrzfl5b7";
  };

  patches = [
    # Fix build on armv6l
    (fetchpatch {
      url = "https://sourceforge.net/p/gnu-efi/patches/_discuss/thread/25bb273a18/9c4d/attachment/0001-Fix-ARCH-on-armv6-and-other-32-bit-ARM-platforms.patch";
      sha256 = "0pj03h20g2bbz6fr753bj1scry6919h57l1h86z3b6q7hqfj0b4r";
    })
  ];

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "HOSTCC=${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  meta = with stdenv.lib; {
    description = "GNU EFI development toolchain";
    homepage = https://sourceforge.net/projects/gnu-efi/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
