{ stdenv, fetchurl, pciutils }:

stdenv.mkDerivation rec {
  name = "gnu-efi-${version}";
  version = "3.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${name}.tar.bz2";
    sha256 = "1bzq5czw5dxlvpgs9ij2iz7q6krwhja87vc982r6vffcqcl0982i";
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
    homepage = http://sourceforge.net/projects/gnu-efi/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
