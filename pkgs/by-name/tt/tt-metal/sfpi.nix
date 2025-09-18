{
  stdenv,
  fetchurl,
  runCommand,
  autoPatchelfHook,
  ncurses,
  isl_0_23,
  mpfr,
  libmpc,
  xz,
}:
let
  version = "6.12.0";
in
runCommand "sfpi-${version}"
  {
    inherit version;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      ncurses
      isl_0_23
      mpfr
      libmpc
      xz
    ];

    src =
      {
        aarch64-linux = fetchurl {
          url = "https://github.com/tenstorrent/sfpi/releases/download/v${version}/sfpi-aarch64_Linux.txz";
          hash = "sha256-4RGwYhsEGx1/ANBUmNeSQcdmMRjFXN8Bg3DICLF6d5o=";
        };
        x86_64-linux = fetchurl {
          url = "https://github.com/tenstorrent/sfpi/releases/download/v${version}/sfpi-x86_64_Linux.txz";
          hash = "sha256-hZvet4ErN1nNScjuU6YW7XEjvV9sR6xvb1IJjgMcXlg=";
        };
      }
      ."${stdenv.hostPlatform.system}" or (throw "SFPI does not support ${stdenv.hostPlatform.system}");
  }
  ''
    runPhase unpackPhase
    cp -r ../"$sourceRoot" "$out"
    runPhase fixupPhase
  ''
