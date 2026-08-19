{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkgsBuildBuild,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jbz";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "jbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3n3Bv3YDb1+MYJTTAmMkIgGY7kX9IVUoDNV4c/n0Ydo=";
  };

  cargoHash = "sha256-U+P2LlhmXwaZy2a2eigrg545HTuV1T01jZfUOEUQ5+w=";

  passthru.runtimeDeps = with pkgsBuildBuild; [
    bacon
    just
  ];

  meta = {
    description = "Display your Just commands wrapped in Bacon";
    homepage = "https://github.com/nim65s/jbz";
    changelog = "https://github.com/nim65s/jbz/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
