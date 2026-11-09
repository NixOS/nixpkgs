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
  version = "0.24.9";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    tag = "xcp-v${finalAttrs.version}";
    hash = "sha256-wTQMaMepYa8mr0I9oXeIDIV4TYhwZTECR5VsWpdmrxA=";
  };

  cargoHash = "sha256-WSUbRn+OJ6bs7G08ntOSXF/Hk8DydI4Hu5qb9eLECHg=";

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # socket copy is not supported on macOS, upstream CI enables this as well
    "test_no_sockets"
  ];

  # had concurrency issues on 64 cores, also tests are quite fast compared to build
  dontUseCargoParallelTests = true;
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # failing in sandbox
    # match on the test function only, test-case >= 3.4 prefixes generated names with `test_case_<n>_`
    "--skip=dir_copy_deref_symlinks::"
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
    changelog = "https://github.com/tarka/xcp/releases/tag/xcp-v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "xcp";
  };
})
