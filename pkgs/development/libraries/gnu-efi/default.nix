{ lib, stdenv, buildPackages, fetchurl, pciutils
, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.18";

  src = fetchurl {
    url = "mirror://sourceforge/gnu-efi/${pname}-${version}.tar.bz2";
    hash = "sha256-fyEslu5mVH7u+1MSZ7ZB5Uc9fYUp8L2Mze/TPPdBP1w=";
  };

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "HOSTCC=${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  postPatch = ''
    substituteInPlace Make.defaults \
      --replace "-Werror" ""
  '';

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.code.sf.net/p/gnu-efi/code";
  };

  meta = with lib; {
    description = "GNU EFI development toolchain";
    homepage = "https://sourceforge.net/projects/gnu-efi/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
