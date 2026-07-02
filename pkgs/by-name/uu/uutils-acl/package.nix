{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "a661fe211a2b6c1881e15bfabe0bd94488445302";
    hash = "sha256-ixXevx72Sg7ExaID8pwUMzc4ujkFSy3qT73dLfJ62IU=";
  };

  cargoHash = "sha256-tz6gCpqlVjdJwzjHdL82V7cUm8Fz/WYCYCAVc16C1SA=";

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
