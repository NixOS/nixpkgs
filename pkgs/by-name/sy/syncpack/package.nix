{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syncpack";
  version = "15.3.2";

  src = fetchFromGitHub {
    owner = "JamieMason";
    repo = "syncpack";
    tag = finalAttrs.version;
    hash = "sha256-hpTVubKPuRtVxjaWetpFaK71UJXMAfOvWCZ4SqgOi0Y=";
  };

  cargoHash = "sha256-sjHyifhKU7FxwxrrAPuMwcUEw0lDGV83mOxXzLZul88=";

  __structuredAttrs = true;

  # This test asserts that a nested .gitignore excludes a build directory, but
  # the `ignore` crate only applies gitignore rules inside a real git repository.
  # The sandbox builds from a source tarball with no .git, so it is skipped here.
  checkFlags = [
    "--skip=issue_334_nested_gitignore_excludes_build_directory"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Consistent dependency versions in large JavaScript monorepos";
    homepage = "https://syncpack.dev";
    changelog = "https://github.com/JamieMason/syncpack/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ELHart05 ];
    mainProgram = "syncpack";
  };
})
