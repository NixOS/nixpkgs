{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-10-17";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "f4273c89827e5099c82340c99fc63ac89aa4fdea";
    hash = "sha256-IyG9GRG2Q6RuocCWV+hTKkhhj2TnAij+qECaMzRz6wY=";
  };

  cargoHash = "sha256-0ncmLwNmdCoNSMG/S25wEZ/VzQzopbHB743GfTYRJL0=";

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
