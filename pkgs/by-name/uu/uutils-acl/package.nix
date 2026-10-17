{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "f99244539cb4ac4e1f7bfa86d8084d0569992aa5";
    hash = "sha256-/QUBm8wWg6EbtE2DThQh4FZKkPuugtkTTWwgJvzGAQ8=";
  };

  cargoHash = "sha256-so2d4/5c5O2z3NpnxWm0IdIFEyqtV25It3ohD7O6m7I=";

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
