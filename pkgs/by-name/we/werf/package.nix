{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  btrfs-progs,
  writableTmpDirAsHomeHook,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "werf";
  version = "2.47.8";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1F/Gy5bKq+08aJaNM5XdI8/z2A6p+4UL+Rf/NXhtWlU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-bmHnpADqmJXMJvPRv7WpnafgPg+ZlwfsvXKdAxW5Ovg=";

  subPackages = [ "cmd/werf" ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ btrfs-progs ]
    ++ lib.optionals stdenv.hostPlatform.isGnu [ stdenv.cc.libc.static ];

  env.CGO_ENABLED = if stdenv.hostPlatform.isLinux then 1 else 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/werf/v2/pkg/werf.Version=v${finalAttrs.version}"
  ]
  ++ lib.optionals (finalAttrs.env.CGO_ENABLED == 1) [
    "-extldflags=-static"
    "-linkmode external"
  ];

  tags = [
    "containers_image_openpgp"
    "dfrunmount"
    "dfrunnetwork"
    "dfrunsecurity"
    "dfssh"
  ]
  ++ lib.optionals (finalAttrs.env.CGO_ENABLED == 1) [
    "cni"
    "exclude_graphdriver_devicemapper"
    "netgo"
    "no_devmapper"
    "osusergo"
    "static_build"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  preCheck = ''
    # Test all packages.
    unset subPackages

    # Remove tests that fail or require external services.
    rm -rf \
      integration/suites \
      pkg/true_git/*_test.go \
      pkg/werf/exec/*_test.go \
      test/e2e
  ''
  + lib.optionalString (finalAttrs.env.CGO_ENABLED == 0) ''
    # A workaround for osusergo.
    export USER=nixbld
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion \
        --cmd werf \
        --$shell <($out/bin/werf completion --shell=$shell)
    done
  '';

  meta = {
    description = "GitOps delivery tool";
    longDescription = ''
      werf is a CNCF Sandbox CLI tool to implement full-cycle CI/CD to
      Kubernetes easily. werf integrates into your CI system and leverages
      familiar and reliable technologies, such as Git, Dockerfile, Helm, and
      Buildah.
    '';
    homepage = "https://werf.io";
    changelog = "https://github.com/werf/werf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "werf";
  };
})
