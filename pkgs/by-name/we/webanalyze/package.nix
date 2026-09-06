{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "webanalyze";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "rverton";
    repo = "webanalyze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kTwBMTmeosfB6L1GzsXjoCvEqmpNtzDBVepbVy0AzlY=";
  };

  vendorHash = "sha256-GesrxrPUMvMFrVPg1t+ArMfbkNUu7CHGmk1423IFnCY=";

  meta = {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    changelog = "https://github.com/rverton/webanalyze/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "webanalyze";
  };
})
