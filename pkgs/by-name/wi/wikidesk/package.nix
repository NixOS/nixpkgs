{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wikidesk";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ilya-epifanov";
    repo = "wikidesk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QAAO1duiYYkU1gl0Jq0EjCSe0Rd/l7er1NdQMM69BKk=";
  };

  cargoHash = "sha256-ISf+v34hBJ7Kizqch82PFzy7+epkOtllyZVbdgh/xBE=";

  __structuredAttrs = true;

  meta = {
    description = "Shared knowledge service for LLM-wiki repositories";
    homepage = "https://github.com/ilya-epifanov/wikidesk";
    changelog = "https://github.com/ilya-epifanov/wikidesk/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    mainProgram = "wikidesk";
  };
})
