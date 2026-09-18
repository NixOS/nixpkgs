{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zat";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "bglgwyng";
    repo = "zat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B/DT8hdtOds9d/od5QInuRu5rBprxzJOfbuj3LkGCvk=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-VSu68KPkoOLyva+A3+TtdTg48xZg0LNenMq+z9xoAVU=";

  meta = {
    description = "Cat files and directories with code outline for LLM coding agents";
    homepage = "https://github.com/bglgwyng/zat";
    changelog = "https://github.com/bglgwyng/zat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "zat";
  };
})
