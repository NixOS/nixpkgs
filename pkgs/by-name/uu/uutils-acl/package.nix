{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "2340e96aa7f23e6f673bffea9e107630f664c669";
    hash = "sha256-9cYALVoY6nvUxOQe1YjrMqqB/yzjCb5dG7XlT2gRLso=";
  };

  cargoHash = "sha256-TK579+8f19GC4Yx7mfeGHvrJd1/D9JwbygjmyV3jy9w=";

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
