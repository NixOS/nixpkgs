{ stdenv, fetchurl, pciutils }:

stdenv.mkDerivation rec {
  name = "gnu-efi-${version}";
  version = "3.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${name}.tar.bz2";
    sha256 = "1jxlypkgb8bd1c114x96i699ib0glb5aca9dv56j377x2ldg4c65";
  };

  buildInputs = [ pciutils ];

  hardening_stackprotector = false;

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
    platforms = platforms.linux;
  };
}
