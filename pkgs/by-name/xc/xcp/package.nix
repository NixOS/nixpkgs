{
  rustPlatform,
  fetchFromGitHub,
  lib,
  acl,
  nix-update-script,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xcp";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ojk2khNLKhnAbWlBG2QEhcVrXz5wuC92IOEG3o58E3A=";
  };

  cargoHash = "sha256-uJVm9nxXXfn4ZEIYoX2XMhZN7Oduwi1D8wZmv64mx60=";

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = lib.optionals stdenv.isLinux [ acl ];

  # disable tests depending on special filesystem features
  checkNoDefaultFeatures = true;
  checkFeatures = [
    "test_no_reflink"
    "test_no_sparse"
    "test_no_extents"
    "test_no_acl"
    "test_no_xattr"
    "test_no_perms"
  ];

  # had concurrency issues on 64 cores, also tests are quite fast compared to build
  dontUseCargoParallelTests = true;
  checkFlags = lib.optionals stdenv.isDarwin [
    # ---- test_socket_file::test_with_parallel_file_driver stdout ----
    # STDOUT: 12:20:56 [WARN] Socket copy not supported by this OS: /private/tmp/nix-build-xcp-0.24.1.drv-0/source/targ>
    #
    # STDERR:
    #
    # thread 'test_socket_file::test_with_parallel_file_driver' panicked at tests/common.rs:1149:5:
    # assertion failed: to.exists()
    # note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
    "--skip=test_socket_file::test_with_parallel_file_driver"

    # ---- test_sockets_dir::test_with_parallel_file_driver stdout ----
    # STDOUT: 12:20:56 [WARN] Socket copy not supported by this OS: /private/tmp/nix-build-xcp-0.24.1.drv-0/source/targ>
    #
    # STDERR:
    #
    # thread 'test_sockets_dir::test_with_parallel_file_driver' panicked at tests/common.rs:1178:5:
    # assertion failed: to.exists()
    "--skip=test_sockets_dir::test_with_parallel_file_driver"
  ];

  postInstall = ''
    installShellCompletion --cmd xcp \
      --bash completions/xcp.bash \
      --fish completions/xcp.fish \
      --zsh completions/xcp.zsh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    changelog = "https://github.com/tarka/xcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lom ];
    mainProgram = "xcp";
  };
})
