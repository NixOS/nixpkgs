{
  btrfs-progs,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "werf";
  version = "3.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ai7EFuJDJBDeHS4CqY3kobG3RZi8Lii82i25kCHaydI=";
  };

  proxyVendor = true;
  vendorHash = "sha256-sA0Vz5UjIL3NfEV5AM8RG9KcQ1QVqQRV79dv+0d/qxI=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ btrfs-progs ]
    ++ lib.optionals stdenv.hostPlatform.isGnu [ stdenv.cc.libc.static ];

  subPackages = [ "cmd/werf" ];

  env.CGO_ENABLED = if stdenv.hostPlatform.isLinux then 1 else 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/werf/v3/pkg/werf.Version=v${finalAttrs.version}"
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
    "exclude_graphdriver_devicemapper"
    "netgo"
    "no_devmapper"
    "osusergo"
    "static_build"
  ];

  # As of 3.0.0 tests are way to burdensome to maintain because of a bespoke way
  # they are handled and a general sandbox incompatability.
  doCheck = false;

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

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

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
