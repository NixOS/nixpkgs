{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tokio-prompt-orchestrator";
  version = "2.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mattbusel";
    repo = "tokio-prompt-orchestrator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0VZNyyYrPr6F1pyX5REV4zSmQr/JhMmnIDvxrfhvnDE=";
  };

  cargoHash = "sha256-q6bJVyP49zALbvvh9YU8MzCwDQYlMJ3/qRI8XudeAt0=";

  # Upstream's .cargo/config.toml moves the target directory, which the
  # cargo install hook does not expect.
  postPatch = ''
    rm .cargo/config.toml
  '';

  # Same features as the upstream install instructions; builds the
  # `orchestrator` proxy binary.
  buildFeatures = [
    "web-api"
    "tantivy"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Local proxy for LLM APIs with request deduplication, a circuit breaker and spend caps";
    homepage = "https://github.com/Mattbusel/tokio-prompt-orchestrator";
    changelog = "https://github.com/Mattbusel/tokio-prompt-orchestrator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattbusel ];
    mainProgram = "orchestrator";
  };
})
