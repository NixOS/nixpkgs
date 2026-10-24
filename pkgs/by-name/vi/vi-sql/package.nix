{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vi-sql";
  version = "0.1.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kopecmaciej";
    repo = "vi-sql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-At3ERFuTyfkhzi12xiLd4XrmyMfgaG5hnvXbEVh6ZKA=";
  };

  vendorHash = "sha256-sMaX1lfBK6SYxQ79Tz5c++Lfe31uCzksH4sR/4ga5pM=";

  ldflags = [
    "-s"
    "-X=github.com/kopecmaciej/vi-sql/internal/build.Version=${finalAttrs.src.tag}"
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI for SQL databases";
    homepage = "https://vi-sql.com/";
    downloadPage = "https://github.com/kopecmaciej/vi-sql";
    changelog = "https://github.com/kopecmaciej/vi-sql/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "vi-sql";
  };
})
