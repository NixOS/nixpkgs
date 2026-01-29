{
  lib,
  src,
  version,
  stdenv,
  llvmPackages,
}:
let
  cross = import ../../../.. {
    system = stdenv.hostPlatform.system;
    crossSystem = lib.systems.examples.riscv32-embedded // {
      libc = null;
      rust.rustcTarget = "riscv32imac-unknown-none-elf";
    };
  };

  inherit (cross) rustPlatform;
in
rustPlatform.buildRustPackage {
  pname = "moondancer";

  inherit src version;

  sourceRoot = "${src.name}/firmware";

  cargoHash = "sha256-G/9evh3G1xNRaaEh6lgDp3hnVlB3MaCwXuhGnGJCd0Q=";

  # fails to build otherwise
  auditable = false;

  nativeBuildInputs = [
    llvmPackages.bintools
  ];

  # ldd removes required symbols without -C link-dead-code
  RUSTFLAGS = "-C linker=lld -C linker-flavor=ld.lld -C link-arg=-Tmemory.x -C link-arg=-Tlink.x -C link-dead-code";

  meta = {
    platforms = [ "riscv32-none" ];
  };
}
