{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-05-29";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "41b2a98f52d4a4d3e87f3debec506b259c296453";
    hash = "sha256-42Eos2bIhA2DTvt9ZYlijtSk075iz/WJAhy5eBf4XAY=";
  };

  cargoHash = "sha256-7kzG0x5UQvF7MRu9tnrnJdhm4zYqrSfUa8mTrnfcIqs=";

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
