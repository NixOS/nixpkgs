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
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "uiua-lang";
    repo = "uiua";
    rev = version;
    hash = "sha256-lqFDzM6EscC8cFPGq/JnEybctaurNRoEQi0zxFaKgwI=";
  };

  cargoHash = "sha256-R97KO3MYmtO9C1Hi9kU+1FDdbOCVQk+gwVXTTvbeok4=";

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
    description = "A stack-oriented array programming language with a focus on simplicity, beauty, and tacit code";
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
