{ lib, release_version }:

{
  llvm_meta = {
    license = lib.licenses.ncsa;
    maintainers = lib.teams.llvm.members;

    # See llvm/cmake/config-ix.cmake.
    platforms =
      lib.platforms.aarch64 ++
      lib.platforms.arm ++
      lib.platforms.mips ++
      lib.platforms.power ++
      lib.platforms.s390x ++
      lib.platforms.wasi ++
      lib.platforms.x86 ++
      lib.optionals (lib.versionAtLeast release_version "7") lib.platforms.riscv ++
      lib.optionals (lib.versionAtLeast release_version "14") lib.platforms.m68k;
  };

}
