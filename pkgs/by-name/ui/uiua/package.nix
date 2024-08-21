{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  audioSupport ? true,
  darwin,
  alsa-lib,

  # passthru.tests.run
  runCommand,
  uiua,
}:

let
  inherit (darwin.apple_sdk.frameworks) AppKit AudioUnit CoreServices;
in
rustPlatform.buildRustPackage rec {
  pname = "uiua";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "uiua-lang";
    repo = "uiua";
    rev = version;
    hash = "sha256-w/eB9EN3IrEDdwbMqj2w5YAZK/BImA/Xq2k9oRng7Zk=";
  };

  cargoHash = "sha256-/DO/jkYaInoO0nMfflDuu7E08gk9D89m9ubeubHdvd8=";

  nativeBuildInputs =
    lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ]
    ++ lib.optionals audioSupport [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.isDarwin [
      AppKit
      CoreServices
    ]
    ++ lib.optionals (audioSupport && stdenv.isDarwin) [ AudioUnit ]
    ++ lib.optionals (audioSupport && stdenv.isLinux) [ alsa-lib ];

  buildFeatures = lib.optional audioSupport "audio";

  passthru.updateScript = ./update.sh;
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
