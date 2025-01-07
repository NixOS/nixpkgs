{
  uiua_versionType ? "stable",

  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,

  libffi,
  audioSupport ? true,
  alsa-lib,
  webcamSupport ? false,

  runCommand,
}:

let
  versionInfo =
    {
      "stable" = import ./stable.nix;
      "unstable" = import ./unstable.nix;
    }
    .${uiua_versionType};
in

# buildRustPackage doesn't support finalAttrs, so we can't use finalPackage for the tests
lib.fix (
  uiua:
  rustPlatform.buildRustPackage rec {
    pname = "uiua";
    inherit (versionInfo) version cargoHash;

    src = fetchFromGitHub {
      owner = "uiua-lang";
      repo = "uiua";
      inherit (versionInfo) rev hash;
    };

    nativeBuildInputs =
      lib.optionals (webcamSupport || stdenv.hostPlatform.isDarwin) [ rustPlatform.bindgenHook ]
      ++ lib.optionals audioSupport [ pkg-config ];

    buildInputs =
      [ libffi ] # we force dynamic linking our own libffi below
      ++ lib.optionals (audioSupport && stdenv.hostPlatform.isLinux) [ alsa-lib ];

    buildFeatures =
      [ "libffi/system" ] # force libffi to be linked dynamically instead of rebuilding it
      ++ lib.optional audioSupport "audio"
      ++ lib.optional webcamSupport "webcam";

    passthru.updateScript = versionInfo.updateScript;
    passthru.tests.run = runCommand "uiua-test-run" { nativeBuildInputs = [ uiua ]; } ''
      uiua init
      diff -U3 --color=auto <(uiua run main.ua) <(echo '"Hello, World!"')
      touch $out
    '';

    meta = {
      changelog = "https://github.com/uiua-lang/uiua/blob/${src.rev}/changelog.md";
      description = "Stack-oriented array programming language with a focus on simplicity, beauty, and tacit code";
      longDescription = ''
        Uiua combines the stack-oriented and array-oriented paradigms in a single
        language. Combining these already terse paradigms results in code with a very
        high information density and little syntactic noise.
      '';
      homepage = "https://www.uiua.org/";
      license = lib.licenses.mit;
      mainProgram = "uiua";
      maintainers = with lib.maintainers; [
        cafkafk
        tomasajt
        defelo
      ];
    };
  }
)
