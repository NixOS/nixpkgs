{ lib, stdenv }:

let
  makeConstants =
    platform:
    let
      os =
        {
          linux = "linux";
          darwin = "macos";
          windows = "windows";
        }
        .${platform.parsed.kernel.name} or (throw "Unsupported OS: ${platform.parsed.kernel.name}");

      arch =
        {
          x86_64 = "amd64";
          aarch64 = "arm64";
          riscv64 = "riscv64";
        }
        .${platform.parsed.cpu.name} or (throw "Unsupported CPU: ${platform.parsed.cpu.name}");
      alt-os = if platform.isDarwin then "mac" else os;
      alt-arch = if platform.isx86_64 then "x64" else arch;
    in
    {
      inherit
        os
        arch
        alt-os
        alt-arch
        ;
      platform = "${os}-${arch}";
      alt-platform = "${alt-os}-${alt-arch}";
    };
in
{
  inherit makeConstants;
  buildConstants = makeConstants stdenv.buildPlatform;
  targetConstants = makeConstants stdenv.targetPlatform;
  hostConstants = makeConstants stdenv.hostPlatform;
}
