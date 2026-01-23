{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typship";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "sjfhsjfh";
    repo = "typship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LDiKAQmzEgzFJH2NAR3FYsO4SmH5uAEOa6I4A0FnwJk=";
  };

  cargoHash = "sha256-t4Vnww49CnkBSRsAWKxSpJffuUuqFAxqUN0GtoxnKLY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true; # From the typst package
  };

  meta = {
    description = "Typst package CLI tool";
    homepage = "https://github.com/sjfhsjfh/typship";
    license = lib.licenses.mit;
    changelog = "https://github.com/sjfhsjfh/typship/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ heijligen ];
  };
})
