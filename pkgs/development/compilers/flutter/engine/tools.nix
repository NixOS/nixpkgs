{
  stdenv,
  buildPlatform,
  hostPlatform,
  callPackage,
  fetchgit,
  fetchurl,
  writeText,
  runCommand,
  darwin,
  writeShellScriptBin,
  depot_toolsCommit ? "580b4ff3f5cd0dcaa2eacda28cefe0f45320e8f7",
  depot_toolsHash ? "sha256-k+XQSYJQYc9vAUjwrRxaAlX/sK74W45m5byS31hSpwc=",
  cipdCommit ? "7120a6a515089a3ff5d1f61ff4ee17750dc038af",
  cipdHashes ? {
    "linux-386" = "sha256-CshLfw49uglvWNwWE4K7ucBUF+IZlXDaIQsTXtFEJ8U=";
    "linux-amd64" = "sha256-rxpI+HqfZiOYvzyyQ9P93s70feDmrLgbm4Xh3o88LwQ=";
    "linux-arm64" = "sha256-XTTKbw1Q2lin+pf7VADalpBy3AWMTEd7yItsE/pePxw=";
    "linux-armv6l" = "sha256-e5qe2KcguRLPuAq6wOG7A3YghHHon+oHY3fRLhU+e9E=";
    "linux-loong64" = "sha256-LPTK4Ly173jac+cSGrsWw0ajrWEYepeJDGtP/7Xh528=";
    "linux-mips" = "sha256-nR5khvHbAijs0MEr8+UgbuHTRNQAsMOyGTU/DI3K5Os=";
    "linux-mips64" = "sha256-4a/zD1CrC/sxtBHqSRpom0SYVoN38bz3FAM40OSdVI0=";
    "linux-mips64le" = "sha256-JnfKuBGLHYNLnRieS0KV8sYaTjh2rbp1yijvNOrU0FE=";
    "linux-mipsle" = "sha256-nWqoay8c4faRk2+G5TvwbsbnndjTU4oglOTfhSC+TLQ=";
    "linux-ppc64" = "sha256-pjeI/bx0i+QchQLhNB88ACPI34SrFvvFA01F5Nb16Ys=";
    "linux-ppc64le" = "sha256-ZDMDwrP1zYlOI1hdbd3iZwKr59v/8CWj2sZ1RdosAiE=";
    "linux-riscv64" = "sha256-O2EvOnjwbNssB7FtbK44yFcXfkrh9HOsPs/HF+uD2m8=";
    "linux-s390x" = "sha256-BKeNDtuc9IkmV4GpuZcdsGc2F039KQeLdozxh7u+FDw=";
    "macos-amd64" = "sha256-ZKBm8PbKjg4t0jIBPRKAv85L8eZOwJ1wBvh3cRSqHOI=";
    "macos-arm64" = "sha256-AvjJp7JF05CetYDnwNJneAsotm1vBHWqB/vCdcIohoU=";
    "windows-386" = "sha256-AVLbWh+WtJKynFDS6IfhuvYudw4Ow9s6w2JyDWG/2CI=";
    "windows-amd64" = "sha256-puAQhiPGuwzkElWiBdTRGWOaUR2AIP7Qv9S3pwEY74E=";
    "windows-arm64" = "sha256-4wxOMG+zvkM7gjhAiQvvNqNS0AamKKJdaBM/+rRxgXk=";
  },
}:
let
  constants = callPackage ./constants.nix { platform = buildPlatform; };
  host-constants = callPackage ./constants.nix { platform = hostPlatform; };
  stdenv-constants = callPackage ./constants.nix { platform = stdenv.hostPlatform; };
in
{
  depot_tools = fetchgit {
    url = "https://chromium.googlesource.com/chromium/tools/depot_tools.git";
    rev = depot_toolsCommit;
    hash = depot_toolsHash;
  };

  cipd =
    let
      unwrapped =
        runCommand "cipd-${cipdCommit}"
          {
            src = fetchurl {
              name = "cipd-${cipdCommit}-unwrapped";
              url = "https://chrome-infra-packages.appspot.com/client?platform=${stdenv-constants.platform}&version=git_revision:${cipdCommit}";
              hash = cipdHashes.${stdenv-constants.platform};
            };
          }
          ''
            mkdir --parents $out/bin
            install --mode=0755 $src $out/bin/cipd
          '';
    in
    writeShellScriptBin "cipd" ''
      params=$@

      if [[ "$1" == "ensure" ]]; then
        shift 1
        params="ensure"

        while [ "$#" -ne 0 ]; do
          if [[ "$1" == "-ensure-file" ]]; then
            ensureFile="$2"
            shift 2
            params="$params -ensure-file $ensureFile"

            sed -i 's/''${platform}/${host-constants.platform}/g' "$ensureFile"
            sed -i 's/gn\/gn\/${stdenv-constants.platform}/gn\/gn\/${constants.platform}/g' "$ensureFile"

            if grep flutter/java/openjdk "$ensureFile" >/dev/null; then
              sed -i '/src\/flutter\/third_party\/java\/openjdk/,+2 d' "$ensureFile"
            fi
          else
            params="$params $1"
            shift 1
          fi
        done
      fi

      exec ${unwrapped}/bin/cipd $params
    '';

  vpython =
    pythonPkg:
    runCommand "vpython3" { } ''
      mkdir --parents $out/bin
      ln --symbolic ${pythonPkg}/bin/python $out/bin/vpython3
    '';

  xcode-select = writeShellScriptBin "xcode-select" ''
    echo ${darwin.xcode}/Contents/Developer
  '';
}
