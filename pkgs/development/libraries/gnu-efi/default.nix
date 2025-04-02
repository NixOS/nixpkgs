{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pciutils,
  gitUpdater,
  fwupd-efi,
  ipxe,
  refind,
  syslinux,
}:

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "ncroxon";
    repo = "gnu-efi";
    rev = version;
    hash = "sha256-xtiKglLXm9m4li/8tqbOsyM6ThwGhyu/g4kw5sC4URY=";
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

  passthru = {
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://git.code.sf.net/p/gnu-efi/code";
    };
    tests = {
      inherit
        fwupd-efi
        ipxe
        refind
        syslinux
        ;
    };
  };

  meta = with lib; {
    description = "GNU EFI development toolchain";
    homepage = "https://sourceforge.net/projects/gnu-efi/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
