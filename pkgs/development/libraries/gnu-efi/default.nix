{ stdenv, fetchurl, pciutils }: with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gnu-efi-${version}";
  version = "3.0.6";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${name}.tar.bz2";
    sha256 = "149cyadpn2jm4zxfn1qmpm520iqssp9p07d650rs5ghgv015jl91";
  };

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "CC=gcc"
    "AS=as"
    "LD=ld"
    "AR=ar"
    "RANLIB=ranlib"
    "OBJCOPY=objcopy"
  ] ++ stdenv.lib.optional stdenv.isArm "ARCH=arm";

  meta = with stdenv.lib; {
    description = "GNU EFI development toolchain";
    homepage = https://sourceforge.net/projects/gnu-efi/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
