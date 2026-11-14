{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-11-14";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "b3a9f4393a8e29d0cfbb3f5c25c426d71ffe2201";
    hash = "sha256-EU22rut95ru8GoGo+8Eflz5FhCEI/Bl5k4KZc+oKBWQ=";
  };

  cargoHash = "sha256-HbH0aLFkohBC/WZuAfxuGWCnbMRi/OAM4Tr7be9lxGQ=";

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
