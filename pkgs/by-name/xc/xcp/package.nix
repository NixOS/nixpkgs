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
  version = "0.24.8";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    tag = "xcp-v${finalAttrs.version}";
    hash = "sha256-OuwzgtMQMQcWhQnwD1Ow2fsT0yhl+DVGkqoebe2osf8=";
  };

  cargoHash = "sha256-8WRiHHMvYwwx7AxuovGjnn83AxIAJK0T86b2WCOtGuw=";

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = lib.optionals stdenv.hostPlatform.isLinux [ acl ];

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
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
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

    # failing in sandbox
    "--skip=dir_copy_deref_symlinks::test_with_parallel_file_driver"
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
    maintainers = [ ];
    mainProgram = "xcp";
  };
})
