{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, audioSupport ? true
, darwin
, alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "uiua";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "uiua-lang";
    repo = "uiua";
    rev = "refs/tags/${version}";
    hash = "sha256-CMuCl4idoO5qIpXdkXBbglsZQBWVT8w9azbn2rRxviA=";
  };

  cargoHash = "sha256-BLP9OGTnksM9NscfhtVWxE0/CqZgkqqlIMgRclCzEzs=";

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    rustPlatform.bindgenHook
  ] ++ lib.optionals audioSupport [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ] ++ lib.optionals (audioSupport && stdenv.isDarwin) [
    darwin.apple_sdk.frameworks.AudioUnit
  ] ++ lib.optionals (audioSupport && stdenv.isLinux) [
    alsa-lib
  ];

  buildFeatures = lib.optional audioSupport "audio";

  meta = with lib; {
    description = "A stack-oriented array programming language with a focus on simplicity, beauty, and tacit code";
    longDescription = ''
      Uiua combines the stack-oriented and array-oriented paradigms in a single
      language. Combining these already terse paradigms results in code with a very
      high information density and little syntactic noise.
    '';
    homepage = "https://www.uiua.org/";
    license = licenses.mit;
    mainProgram = "uiua";
    maintainers = with maintainers; [ cafkafk tomasajt ];
  };
}
