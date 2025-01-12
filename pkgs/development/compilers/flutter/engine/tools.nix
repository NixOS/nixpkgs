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
  depot_toolsCommit ? "7d95eb2eb054447592585c73a8ff7adad97ecba1",
  depot_toolsHash ? "sha256-F7KDuVg11qLKkohIjuXpNdxpnSsT6Z3hE9+wFIG2sSk=",
  cipdCommit ? "89ada246fcbf10f330011e4991d017332af2365b",
  cipdHashes ? {
    "linux-386" = "7f264198598af2ef9d8878349d33c1940f1f3739e46d986962c352ec4cce2690";
    "linux-amd64" = "2ada6b46ad1cd1350522c5c05899d273f5c894c7665e30104e7f57084a5aeeb9";
    "linux-arm64" = "96eca7e49f6732c50122b94b793c3a5e62ed77bce1686787a8334906791b4168";
    "linux-armv6l" = "06394601130652c5e1b055a7e4605c21fc7c6643af0b3b3cac8d2691491afa81";
    "linux-mips64" = "f3eda6542b381b7aa8f582698498b0e197972c894590ec35f18faa467c868f5c";
    "linux-mips64le" = "74229ada8e2afd9c8e7c58991126869b2880547780d4a197a27c1dfa96851622";
    "linux-mipsle" = "2f3c18ec0ad48cd44a9ff39bb60e9afded83ca43fb9c7a5ea9949f6fdd4e1394";
    "linux-ppc64" = "79425c0795fb8ba12b39a8856bf7ccb853e85def4317aa6413222f307d4c2dbd";
    "linux-ppc64le" = "f9b3d85dde70f1b78cd7a41d2477834c15ac713a59317490a4cdac9f8f092325";
    "linux-riscv64" = "bd695164563a66e8d3799e8835f90a398fbae9a4eec24e876c92d5f213943482";
    "linux-s390x" = "6f501af80541e733fda23b4208a21ea05919c95d236036a2121e6b6334a2792c";
    "macos-amd64" = "41d05580c0014912d6c32619c720646fd136e4557c9c7d7571ecc8c0462733a1";
    "macos-arm64" = "dc672bd16d9faf277dd562f1dc00644b10c03c5d838d3cc3d3ea29925d76d931";
    "windows-386" = "fa6ed0022a38ffc51ff8a927e3947fe7e59a64b2019dcddca9d3afacf7630444";
    "windows-amd64" = "b5423e4b4429837f7fe4d571ce99c068aa0ccb37ddbebc1978a423fd2b0086df";
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
              sha256 = cipdHashes.${stdenv-constants.platform};
            };
          }
          ''
            mkdir -p $out/bin
            install -m755 $src $out/bin/cipd
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
    runCommand "vpython3" { } "mkdir -p $out/bin && ln -s ${pythonPkg}/bin/python $out/bin/vpython3";

  xcode-select = writeShellScriptBin "xcode-select" ''
    echo ${darwin.xcode}/Contents/Developer
  '';
}
