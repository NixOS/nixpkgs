{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "63cf10a4ad60a265fa02c8b3beef07111177022f";
    hash = "sha256-ldKrI2D+A6eZMgfL2X4oFpWVq+gwQigBWlDTk/23t54=";
  };

  cargoHash = "sha256-9V5uzF2mlZDSHrpuxygkTKybZjALz7M6Bf12RHQa3IQ=";

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
