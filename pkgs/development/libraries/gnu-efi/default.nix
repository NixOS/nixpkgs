{ stdenv, buildPackages, fetchurl, pciutils }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    sha256 = "1w3p4aqlc5j93q44la7dc8cr3hky20zvsd0h0k2lyzhwmrzfl5b7";
  };

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
