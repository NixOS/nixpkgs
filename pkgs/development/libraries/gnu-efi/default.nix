{ stdenv, fetchurl, pciutils }: with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gnu-efi-${version}";
  version = "3.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${name}.tar.bz2";
    sha256 = "1w3p4aqlc5j93q44la7dc8cr3hky20zvsd0h0k2lyzhwmrzfl5b7";
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
