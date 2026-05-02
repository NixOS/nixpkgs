{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "68816cd43f14c85b3579417556b05be380a35128";
    hash = "sha256-nBlGo0xNSQ1Ees/+vVYrIm6CDVtofFWhqW0QDHR+zok=";
  };

  cargoHash = "sha256-lswm5OxVHfo7eTlvkWVLqmno5AfiGggWORtzGmnLEm4=";

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
