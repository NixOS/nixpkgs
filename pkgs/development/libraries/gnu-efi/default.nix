{ lib, stdenv, buildPackages, fetchurl, pciutils }:

with lib;

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.13";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    sha256 = "sha256-L8z3FSecRu5pxIWRhq+BUNB6E/TRmHblRZzWW+gtO30=";
  };

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
