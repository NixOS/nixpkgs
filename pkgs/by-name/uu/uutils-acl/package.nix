{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-05-17";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "8c23acae9473c2a6a425a95eda474cdec33fb9a4";
    hash = "sha256-q1dMJMMhL7/vA1ffy4KBhoPx7BoZnnr7yxLc9XDOCak=";
  };

  cargoHash = "sha256-06gamu+PZK68QSA4vLYyjRS6ecO/ugjkmaHH2tipTl4=";

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
