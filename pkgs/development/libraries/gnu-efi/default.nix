{ lib, stdenv, buildPackages, fetchpatch, fetchurl, pciutils, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.17";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    sha256 = "sha256-eAfpAzSTQ6ehQuu5NHA6KHIjXolojPWGwDKwoQh7yvQ=";
  };

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  patches = [
    (fetchpatch {
      url = "https://sourceforge.net/p/gnu-efi/patches/88/attachment/riscv64-fix-efibind.h-missing-duplicate-types.patch";
      sha256 = "sha256-fUAxj1/U9J2A1zMEdnh62+WnVmQ9hrrYwMFppBz1Y1g=";
    })
  ];

  makeFlags = [
    "PREFIX=\${out}"
    "HOSTCC=${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.code.sf.net/p/gnu-efi/code";
  };

  meta = with lib; {
    description = "GNU EFI development toolchain";
    homepage = "https://sourceforge.net/projects/gnu-efi/";
    license = licenses.bsd3;
    platforms = remove "riscv32-linux" platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
