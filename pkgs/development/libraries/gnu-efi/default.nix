{ lib, stdenv, buildPackages, fetchFromGitHub, fetchpatch, pciutils
, gitUpdater, fwupd-efi, ipxe, refind, syslinux }:

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "ncroxon";
    repo = "gnu-efi";
    rev = version;
    hash = "sha256-xtiKglLXm9m4li/8tqbOsyM6ThwGhyu/g4kw5sC4URY=";
  };

  patches = [
    # Backport patch fixing memory corruption in rEFInd
    (fetchpatch {
      url = "https://github.com/ncroxon/gnu-efi/commit/f5bb548df572c992fe3389a586bec3a19b092c18.diff";
      hash = "sha256-lImlcFUWKwm3u5srFkZa0QOQzUcpNfqPXOpVlh7d390=";
    })
    (fetchpatch {
      url = "https://github.com/ncroxon/gnu-efi/commit/6b9dae0bef0fab82230a6672eaadd38d739e3e1e.diff";
      hash = "sha256-1CRD8EY/RGdi7zEQ8NZ+OjA74xZrvNnAkUG8JkJ8/Y4=";
    })
  ];

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
      inherit fwupd-efi ipxe refind syslinux;
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
