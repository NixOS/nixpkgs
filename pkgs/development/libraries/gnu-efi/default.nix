{ lib, stdenv, buildPackages, fetchurl, pciutils
, gitUpdater }:

with lib;

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.14";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    sha256 = "tztkOg1Wl9HzltdDFEjoht2AVmh4lXjj4aKCd8lShDU=";
  };

  patches = [
    # Pull fix pending upstream inclusion for parallel builds
    #  https://sourceforge.net/p/gnu-efi/patches/84/
    (fetchurl {
      name = "parallel-build.patch";
      url = "https://sourceforge.net/p/gnu-efi/patches/84/attachment/0001-lib-Makefile-add-.o-file-dependency-on-libsubdirs-ta.patch";
      sha256 = "sha256-+2UwV2lopdB/tazib1BLzO1E3GgB1L8dZsSQKWVoLwA=";
    })
  ];

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "HOSTCC=${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  passthru.updateScript = gitUpdater {
    inherit pname version;
    # No nicer place to find latest release.
    url = "https://git.code.sf.net/p/gnu-efi/code";
  };

  meta = with lib; {
    description = "GNU EFI development toolchain";
    homepage = "https://sourceforge.net/projects/gnu-efi/";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
