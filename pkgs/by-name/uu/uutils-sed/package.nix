{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-sed";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "sed";
    tag = finalAttrs.version;
    hash = "sha256-r7roYjhR//MQ0ZK4YwDIZhtijxJCY1QofJk0rIsYPzA=";
  };

  cargoHash = "sha256-gcFMYF8effLwMPLVU78f419UFtJz2KGv2gVZw8kOdPI=";

  # Upstream tests assume stderr is not a terminal; some builders attach a pty.
  env.UUTILS_DIAG = "never";

  meta = {
    changelog = "https://github.com/uutils/sed/releases/tag/${finalAttrs.version}";
    description = "Rewrite of sed in Rust";
    homepage = "https://github.com/uutils/sed";
    license = lib.licenses.mit;
    mainProgram = "sed";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
