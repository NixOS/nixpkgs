{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "b3e1a9ea9f9eaab2b9a877fba5b6b00e1a170341";
    hash = "sha256-6sopMhh1swsoORjnFTzMB0Q8SqtIjRTHxGfFyw6L7rM=";
  };

  cargoHash = "sha256-dfJibUOjSsxY5cfwy6khc5IXWA/AtoAZAmzCledB59s=";

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
