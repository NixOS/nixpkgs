{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "f5d374af73ec0206a6ea3106052550f873d5bcd8";
    hash = "sha256-38Mp2ue89e7fLYaGwJsbkq+4l25gQDfVeJMY2ZAjJ8c=";
  };

  cargoHash = "sha256-5rHHhs+Hz0Yzvi5V1D2NPR6l5juP4BvjJve+8bbWbXc=";

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
