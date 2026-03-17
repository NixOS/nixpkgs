{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-03-13";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "4a80f872ef659f6406c1ce70266ed68a502eb8b7";
    hash = "sha256-hrE2At1heNwxAQ9wjtJCS+ecX1hm3Y+2T202jYlk9rQ=";
  };

  cargoHash = "sha256-dQ+G3aXVRRwWD94WpGCpt3nHQEK77He2UDQYZSpSWRM=";

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
