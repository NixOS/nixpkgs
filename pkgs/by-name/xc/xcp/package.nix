{
  rustPlatform,
  fetchFromGitHub,
  lib,
  acl,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xcp";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TI9lveFJsb/OgGQRiPW5iuatB8dsc7yxBs1rb148nEY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9cNu0cgoo0/41daJwy/uWIXa2wFhYkcPhJfA/69DVx0=";

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
  checkFlags =
    [
      # had concurrency issues on 64 cores, also tests is quiet fast compared to build
      "--test-threads=1"
    ]
    ++ lib.optionals stdenv.isDarwin [
    # failures:
    #
    # ---- test_socket_file::test_with_parallel_file_driver stdout ----
    # STDOUT: 12:20:56 [WARN] Socket copy not supported by this OS: /private/tmp/nix-build-xcp-0.24.1.drv-0/source/targ>
    #
    # STDERR:
    #
    # thread 'test_socket_file::test_with_parallel_file_driver' panicked at tests/common.rs:1149:5:
    # assertion failed: to.exists()
    # note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
    #
    # ---- test_sockets_dir::test_with_parallel_file_driver stdout ----
    # STDOUT: 12:20:56 [WARN] Socket copy not supported by this OS: /private/tmp/nix-build-xcp-0.24.1.drv-0/source/targ>
    #
    # STDERR:
    #
    # thread 'test_sockets_dir::test_with_parallel_file_driver' panicked at tests/common.rs:1178:5:
    # assertion failed: to.exists()
     "--skip=test_socket_file::test_with_parallel_file_driver"
     "--skip=test_sockets_dir::test_with_parallel_file_driver"
  ];

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
