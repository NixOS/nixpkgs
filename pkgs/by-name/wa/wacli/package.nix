{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "wacli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qEEiqX0r6iIm5STYxpaHuXdbtaQKigSGD8jLECbsW/0=";
  };

  vendorHash = "sha256-A5XDBUYHsNVnIJ5TBt8ePSY5oWlyjsYxp6u9169vy9I=";

  # Enables SQLite FTS5 (full-text search) in mattn/go-sqlite3 for message history search
  tags = [ "sqlite_fts5" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/wacli" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "WhatsApp CLI built on whatsmeow";
    homepage = "https://github.com/steipete/wacli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "wacli";
  };
})
