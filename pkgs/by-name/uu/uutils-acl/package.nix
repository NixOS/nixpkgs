{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-acl";
  version = "0.0.1-unstable-2026-02-04";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "acl";
    rev = "8ba4838795d65b63f4bd6b7f945c4f92932e95e3";
    hash = "sha256-mamqwBwTBnuf+XPT492F3GRSoX0Kj7dLKxhLLYRzNII=";
  };

  cargoHash = "sha256-JvGIEBUjpH/6V53VJKi27XdNi3rDd6u7j+NtW/Pq8cQ=";

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
