{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "a23cca6b74993aa522608b7ae4a70f2c88df2e6c";
    hash = "sha256-54f5798l6CcpJgHV15gcMusOMKof1LOC4p0KQ65C/TU=";
  };

  cargoHash = "sha256-tw7vecIyZYfd8jiLvU2fMVMo7KGOYFPObaW3LlRSJaY=";

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
