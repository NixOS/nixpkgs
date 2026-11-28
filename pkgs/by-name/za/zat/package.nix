{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zat";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "bglgwyng";
    repo = "zat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HFFVsfbT5syDxKO8ECPBIHqzJxIKAvp7X7O7Cji2Sxk=";
  };

  cargoPatches = [
    # Update outdated tree-sitter-haskell dependecy
    # TODO: Remove this patch when PR is merged/updated tree-sitter-haskell to newer version
    (fetchpatch2 {
      name = "tree-sitter-haskell-update.patch";
      url = "https://github.com/bglgwyng/zat/commit/38b32082301eb7dffcedcd641c9a102512055064.patch?full_index=1";
      hash = "sha256-4Z3I6XA4taA7YyvmAjjcJodgKk2x6PFJE/6t/SnpOdg=";
    })
  ];

  __structuredAttrs = true;

  cargoHash = "sha256-4NHV+ij01lBPSOTM5bmBdk1G3+hPRJHQbfp6t3jHlNk=";

  meta = {
    description = "Cat files and directories with code outline for LLM coding agents";
    homepage = "https://github.com/bglgwyng/zat";
    changelog = "https://github.com/bglgwyng/zat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "zat";
  };
})
