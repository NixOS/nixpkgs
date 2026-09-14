{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "b5d1996d6cddd10e4fad219e9dae70bfae1d4dbc";
    hash = "sha256-bQpi2U+BJmOGXx08udtfT/qpdpFJypR0qBjsflT9YHU=";
  };

  cargoHash = "sha256-p2e3ZInUhOz0zW7o9ZIQsM8yxP9XASYg0CDpls3XtXM=";

  cargoBuildFlags = [ "--workspace" ];

  checkFlags = [
    # Operation not supported
    "--skip=common::util::tests::test_compare_xattrs"
    # assertion failed
    "--skip=test_setfacl::test_invalid_arg"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the acl project";
    homepage = "https://github.com/uutils/acl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
