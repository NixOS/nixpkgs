{
  lib,
  buildGoModule,
  fetchFromGitHub,
  iana-etc,
  installShellFiles,
  libredirect,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "zarf";
  version = "0.77.0";

  src = fetchFromGitHub {
    owner = "zarf-dev";
    repo = "zarf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kVXJ0ByW/v68f65tmgsvvHnp5v9x4y4vq6Qnu5kA9ZQ=";
  };

  vendorHash = "sha256-xP0hXk6D/EzgxVYScOnET203ip390zgxIr5fAEj7wqI=";
  proxyVendor = true;

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  preBuild = ''
    mkdir -p build/ui
    touch build/ui/index.html
    rm -rf hack/schema
  '';

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/zarf-dev/zarf/src/config.CLIVersion=${finalAttrs.src.tag}"
    "-X"
    "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${finalAttrs.src.tag}"
    "-X"
    "k8s.io/component-base/version.gitCommit=${finalAttrs.src.tag}"
    "-X"
    "k8s.io/component-base/version.buildDate=1970-01-01T00:00:00Z"
  ];

  postInstall =
    lib.optionalString
      (stdenv.buildPlatform.canExecute stdenv.hostPlatform && stdenv.hostPlatform.isDarwin)
      "export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services"
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      export K9S_LOGS_DIR=$(mktemp -d)
      installShellCompletion --cmd zarf \
        --bash <($out/bin/zarf completion bash) \
        --fish <($out/bin/zarf completion fish) \
        --zsh  <($out/bin/zarf completion zsh)
    '';

  meta = {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    mainProgram = "zarf";
    homepage = "https://zarf.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ragingpastry
    ];
  };
})
