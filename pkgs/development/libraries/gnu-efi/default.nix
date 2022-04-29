{ lib, stdenv, buildPackages, fetchurl, fetchpatch, pciutils }:

with lib;

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.11";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    sha256 = "1ffnc4xbzfggs37ymrgfx76j56kk2644c081ivhr2bjkla9ag3gj";
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

  meta = with lib; {
    description = "GNU EFI development toolchain";
    homepage = "https://sourceforge.net/projects/gnu-efi/";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
