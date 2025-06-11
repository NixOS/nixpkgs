{ lib, platform }:
let
  self = {
    os =
      if platform.isLinux then
        "linux"
      else if platform.isDarwin then
        "macos"
      else if platform.isWindows then
        "windows"
      else
        throw "Unsupported OS \"${platform.parsed.kernel.name}\"";

    alt-os = if platform.isDarwin then "mac" else self.os;

    arch =
      if platform.isx86_64 then
        "amd64"
      else if platform.isx86 && platform.is32bit then
        "386"
      else if platform.isAarch64 then
        "arm64"
      else if platform.isMips && platform.parsed.cpu.significantByte == "littleEndian" then
        "mipsle"
      else if platform.isMips64 then
        "mips64${lib.optionalString (platform.parsed.cpu.significantByte == "littleEndian") "le"}"
      else if platform.isPower64 then
        "ppc64${lib.optionalString (platform.parsed.cpu.significantByte == "littleEndian") "le"}"
      else if platform.isS390x then
        "s390x"
      else if platform.isRiscV64 then
        "riscv64"
      else
        throw "Unsupported CPU \"${platform.parsed.cpu.name}\"";

    alt-arch =
      if platform.isx86_64 then
        "x64"
      else if platform.isAarch64 then
        "arm64"
      else
        platform.parsed.cpu.name;

    platform = "${self.os}-${self.arch}";
    alt-platform = "${self.os}-${self.alt-arch}";
  };
in
self
