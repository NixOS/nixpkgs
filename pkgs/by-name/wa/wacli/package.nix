{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoLatestModule (finalAttrs: {
  pname = "wacli";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "wacli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hbJcS22EtgxgJ0wK3dlqkBF/FTAs4zdOthr3st/4x3o=";
  };

  vendorHash = "sha256-E/LnctFkSYMctq2wJaCjjUip7UPniNVEVwxQ6ewUIxo=";

  # Enables SQLite FTS5 (full-text search) in mattn/go-sqlite3 for message history search
  tags = [ "sqlite_fts5" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/wacli" ];

  __structuredAttrs = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "WhatsApp CLI built on whatsmeow";
    homepage = "https://github.com/openclaw/wacli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "wacli";
  };
})
