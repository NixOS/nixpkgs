{ stdenv, fetchurl, pciutils }: with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.11";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    sha256 = "1ffnc4xbzfggs37ymrgfx76j56kk2644c081ivhr2bjkla9ag3gj";
  };

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "CC=${stdenv.cc.targetPrefix}gcc"
    "AS=${stdenv.cc.targetPrefix}as"
    "LD=${stdenv.cc.targetPrefix}ld"
    "AR=${stdenv.cc.targetPrefix}ar"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
    "OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
  ] ++ stdenv.lib.optional stdenv.isAarch32 "ARCH=arm"
    ++ stdenv.lib.optional stdenv.isAarch64 "ARCH=aarch64";

  meta = with stdenv.lib; {
    description = "GNU EFI development toolchain";
    homepage = https://sourceforge.net/projects/gnu-efi/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
