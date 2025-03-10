{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pciutils,
  fwupd-efi,
  ipxe,
  refind,
  syslinux,
}:

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "ncroxon";
    repo = "gnu-efi";
    rev = version;
    hash = "sha256-vVtJkAPe5tPDLAFZibnJRC7G7WtOg11JT5QipdO+FIk=";
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

  passthru.tests = {
    inherit
      fwupd-efi
      ipxe
      refind
      syslinux
      ;
  };

  meta = {
    description = "GNU EFI development toolchain";
    homepage = "https://github.com/ncroxon/gnu-efi";
    license = with lib.licenses; [
      bsd2Patent
      efilib
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
