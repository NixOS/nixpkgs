{
  lib,
  stdenv,
  fetchurl,
  SDL,
  curl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyemu";
  version = "2019-12-21";

  src = fetchurl {
    url = "https://bellard.org/tinyemu/tinyemu-${finalAttrs.version}.tar.gz";
    hash = "sha256-voNR8hIYGbMXL87c5csYJvoSyH2ht+2Y8mnT6AKgVVU=";
  };

  nativeBuildInputs = [ SDL ];

  buildInputs = [
    SDL
    curl
    openssl
  ];

  strictDeps = true;

  makeFlags = [
    "CC:=$(CC)"
    "STRIP:=$(STRIP)"
    "bindir=$(out)/bin"
  ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = {
    homepage = "https://bellard.org/tinyemu/";
    description = "System emulator for the RISC-V and x86 architectures";
    longDescription = ''
      TinyEMU is a system emulator for the RISC-V and x86 architectures. Its
      purpose is to be small and simple while being complete.

      Main features:

      - RISC-V system emulator supporting the RV128IMAFDQC base ISA (user level
        ISA version 2.2, priviledged architecture version 1.10) including:
        - 32/64/128 bit integer registers
        - 32/64/128 bit floating point instructions (using the SoftFP Library)
        - Compressed instructions
        - Dynamic XLEN change
      - x86 system emulator based on KVM
      - VirtIO console, network, block device, input and 9P filesystem
      - Graphical display with SDL
      - JSON configuration file
      - Remote HTTP block device and filesystem
      - Small code, easy to modify, few external dependancies
      - Javascript version running Linux and Windows 2000.
    '';
    license = with lib.licenses; [
      mit
      bsd2
    ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
