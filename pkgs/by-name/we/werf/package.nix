{
  btrfs-progs,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "werf";
  version = "2.70.0";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Oe/IjmzD7+LE6OVLACDgknrl4cb9yJ/lDvKBjrvFNQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-iMoR38Qb2utzdkhKUrCQ0Ohm8f6jdYTuLkeMhCLqvN4=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ btrfs-progs ]
    ++ lib.optionals stdenv.hostPlatform.isGnu [ stdenv.cc.libc.static ];

  subPackages = [ "cmd/werf" ];

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
      pkg/container_backend/buildah_backend_data_archives_test.go \
      pkg/true_git/*_test.go \
      pkg/werf/exec/*_test.go \
      test/e2e \
      test/legacy_e2e
  ''
  + lib.optionalString (finalAttrs.env.CGO_ENABLED == 0) ''
    # A workaround for osusergo.
    export USER=nixbld
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
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
