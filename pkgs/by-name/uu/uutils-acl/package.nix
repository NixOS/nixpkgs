{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-04-01";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "0a1ca1c6269a6cb233c3f46486b750c4f4317486";
    hash = "sha256-Rxl0FQuwzSA7dCXIXLtWUeQPc8ehNXBFillZVxJQggM=";
  };

  cargoHash = "sha256-VaFEPOjvsuUyFQ6xhuTkAt/R7Q3u/kZwU75/BK5xqB8=";

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
