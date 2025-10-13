{
  lib,
  buildGoModule,
  fetchFromGitHub,
  iana-etc,
  installShellFiles,
  libredirect,
  stdenv,
}:

buildGoModule rec {
  pname = "zarf";
  version = "0.62.0";

  src = fetchFromGitHub {
    owner = "zarf-dev";
    repo = "zarf";
    tag = "v${version}";
    hash = "sha256-mabp4G7LbtOmIVEmOK/YhjTX/RRM8ObAS6YXTJe2P/U=";
  };

  vendorHash = "sha256-As7xDEo+bMslv9Xd6CbHTqvf2XaXmO6Gp3f9+xD3kNU=";
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
    "github.com/zarf-dev/zarf/src/config.CLIVersion=${src.tag}"
    "-X"
    "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${src.tag}"
    "-X"
    "k8s.io/component-base/version.gitCommit=${src.tag}"
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

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    mainProgram = "zarf";
    homepage = "https://zarf.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ragingpastry
    ];
  };
}
