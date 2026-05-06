{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wacli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "wacli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tJ5d33VVW5aYvacHJEVm8cVKVtpdWCIOdHNy2WTR4Cg=";
  };

  vendorHash = "sha256-0mHZjZHQBHTlPzVT4ScyRBSaQ4Z8FEm2GFfsPF6Tjrw=";

  # Enables SQLite FTS5 (full-text search) in mattn/go-sqlite3 for message history search
  tags = [ "sqlite_fts5" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/wacli" ];

  meta = {
    description = "WhatsApp CLI built on whatsmeow";
    homepage = "https://github.com/steipete/wacli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "wacli";
  };
})
