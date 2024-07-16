{ lib, targetPlatform }:
rec {
  os =
    if targetPlatform.isLinux then
      "linux"
    else if targetPlatform.isDarwin then
      "macos"
    else if targetPlatform.isWindows then
      "windows"
    else
      throw "Unsupported OS \"${targetPlatform.parsed.kernel.name}\"";

  arch =
    if targetPlatform.isx86_64 then
      "amd64"
    else if targetPlatform.isx86 && targetPlatform.is32bit then
      "386"
    else if targetPlatform.isAarch64 then
      "arm64"
    else if targetPlatform.isMips && targetPlatform.parsed.cpu.significantByte == "littleEndian" then
      "mipsle"
    else if targetPlatform.isMips64 then
      "mips64${lib.optionalString (targetPlatform.parsed.cpu.significantByte == "littleEndian") "le"}"
    else if targetPlatform.isPower64 then
      "ppc64${lib.optionalString (targetPlatform.parsed.cpu.significantByte == "littleEndian") "le"}"
    else if targetPlatform.isS390x then
      "s390x"
    else
      throw "Unsupported CPU \"${targetPlatform.parsed.cpu.name}\"";

  alt-arch =
    if targetPlatform.isx86_64 then
      "x64"
    else if targetPlatform.isAarch64 then
      "arm64"
    else
      targetPlatform.parsed.cpu.name;

  platform = "${os}-${arch}";
  alt-platform = "${os}-${alt-arch}";
}
