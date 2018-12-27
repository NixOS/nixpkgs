{ lib }:

rec {
  llvmBackend = platform:
    if builtins.typeOf platform == "string" then
      platform
    else if platform.parsed.cpu.family == "x86" then
      "X86"
    else if platform.parsed.cpu.name == "aarch64" then
      "AArch64"
    else if platform.parsed.cpu.family == "arm" then
      "ARM"
    else if platform.parsed.cpu.family == "mips" then
      "Mips"
    else
      throw "Unsupported system";

  llvmBackendList = platforms:
    lib.concatStringsSep ";" (map llvmBackend platforms);
}
