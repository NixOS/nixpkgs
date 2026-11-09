{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  autoPatchelfHook,
  ncurses,
  mpfr,
  libmpc,
  xz,
  zstd,
  expat,
}:
let
  version = "7.85.0";
in
runCommand "sfpi-${version}"
  {
    inherit version;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    # patchelf 0.19 makes cc1plus segfault with the default 4 KiB page size
    patchelfFlags = [
      "--page-size"
      "65536"
    ];

    buildInputs = [
      ncurses
      mpfr
      libmpc
      xz
      zstd
      expat
    ];

    src =
      {
        aarch64-linux = fetchurl {
          url = "https://github.com/tenstorrent/sfpi/releases/download/${version}/sfpi_${version}_aarch64_debian.txz";
          hash = "sha256-QumjtO4FNdKYgqEc2PEhpDvdairFmzhDJcAdgEEULhU=";
        };
        x86_64-linux = fetchurl {
          url = "https://github.com/tenstorrent/sfpi/releases/download/${version}/sfpi_${version}_x86_64_debian.txz";
          hash = "sha256-m4iWjFceMWWKg0iwQuNumIsM8O8EeMBQa4B4w/tROcM=";
        };
      }
      ."${stdenv.hostPlatform.system}" or (throw "SFPI does not support ${stdenv.hostPlatform.system}");
  }
  ''
    runPhase unpackPhase
    cp -r ../"$sourceRoot" "$out"
    runPhase fixupPhase
  ''
