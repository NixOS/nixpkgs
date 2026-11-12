{
  lib,
  src,
  version,
  stdenv,
  llvmPackages,
}:
let
  # Moondancer SoC firmware, cross-compiled for the bare-metal riscv32imac
  # VexRiscv softcore inside the facedancer gateware.
  cross = import ../../../.. {
    localSystem = stdenv.hostPlatform.system;
    crossSystem = lib.systems.examples.riscv32-embedded // {
      rust.rustcTarget = "riscv32imac-unknown-none-elf";
    };
  };

  inherit (cross) rustPlatform;
in
rustPlatform.buildRustPackage {
  pname = "moondancer";

  inherit version src;

  sourceRoot = "${src.name}/firmware";

  cargoHash = "sha256-G/9evh3G1xNRaaEh6lgDp3hnVlB3MaCwXuhGnGJCd0Q=";

  # fails to build otherwise
  auditable = false;

  nativeBuildInputs = [
    llvmPackages.bintools
  ];

  # lld strips live code without link-dead-code; memory.x (workspace root) and
  # link.x (from riscv-rt) are the linker scripts.
  RUSTFLAGS = "-C linker=lld -C link-arg=-Tmemory.x -C link-arg=-Tlink.x -C link-dead-code";

  # cynthion flash needs a raw image, not an ELF (as upstream's
  # `cargo objcopy -Obinary`).
  postInstall = ''
    llvm-objcopy -O binary \
      $out/bin/moondancer \
      $out/bin/moondancer.bin
  '';

  meta = {
    description = "Moondancer SoC firmware for the Great Scott Gadgets Cynthion";
    homepage = "https://github.com/greatscottgadgets/cynthion";
    license = lib.licenses.bsd3;
    platforms = [ "riscv32-none" ];
  };
}
