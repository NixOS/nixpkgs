{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "8983e202030dae1751f6e647742b4d5febf940bd";
    hash = "sha256-YdPg2TzFrApMy1XMZTaZikcNzDGEDsLFZb3lHEtbwgw=";
  };

  cargoHash = "sha256-22Fz+PKjDlikHDv7rWIat8hCj/uS5V9XRkCxuuIBtVk=";

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
