{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "67eeade4a032d75e953981061ad43df60c345ae0";
    hash = "sha256-z2VkJcVYH7NYX6Asa6DQ0/2HYNZyaQB6Fp2fok67dbA=";
  };

  cargoHash = "sha256-EjiRMJ62XljHjm1e9gIX4BVE416IccVpCUe5L3cDn5k=";

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
