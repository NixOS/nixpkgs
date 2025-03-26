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

buildGoModule rec {
  pname = "werf";
  version = "2.31.1";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    tag = "v${version}";
    hash = "sha256-eEdhAY3vN6hsgggakYpGFiVjR2BBGrg1UF18gFXc8g8=";
  };

  vendorHash = "sha256-g+QZI0mfXSIU+iBnKzMeTGuF5UB1cwOixvRhcrBGrpE=";

  proxyVendor = true;

  subPackages = [ "cmd/werf" ];

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ btrfs-progs ]
    ++ lib.optionals stdenv.hostPlatform.isGnu [ stdenv.cc.libc.static ];

  env.CGO_ENABLED = if stdenv.hostPlatform.isLinux then 1 else 0;

  ldflags =
    [
      "-s"
      "-w"
      "-X github.com/werf/werf/v2/pkg/werf.Version=v${version}"
    ]
    ++ lib.optionals (env.CGO_ENABLED == 1) [
      "-extldflags=-static"
      "-linkmode external"
    ];

  tags =
    [
      "containers_image_openpgp"
      "dfrunmount"
      "dfrunnetwork"
      "dfrunsecurity"
      "dfssh"
    ]
    ++ lib.optionals (env.CGO_ENABLED == 1) [
      "cni"
      "exclude_graphdriver_devicemapper"
      "netgo"
      "no_devmapper"
      "osusergo"
      "static_build"
    ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  preCheck =
    ''
      # Test all packages.
      unset subPackages

      # Remove tests that require external services, usually a Docker daemon.
      rm -rf \
        integration/suites \
        pkg/true_git/*_test.go \
        test/e2e
    ''
    + lib.optionalString (env.CGO_ENABLED == 0) ''
      # A workaround for osusergo.
      export USER=nixbld
    '';

  doInstallCheck = true;

  versionCheckProgramArg = "version";

  postInstall = ''
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
    changelog = "https://github.com/werf/werf/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "werf";
  };
}
