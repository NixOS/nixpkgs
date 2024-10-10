{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tctl";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    hash = "sha256-LX4hyPme+mkNmPvrTHIT5Ow3QM8BTAB7MXSY1fa8tSk=";
  };

  vendorHash = "sha256-294lnUKnXNrN6fJ+98ub7LwsJ9aT+FzWCB3nryfAlCI=";

  overrideModAttrs = old: {
    # https://gitlab.com/cznic/libc/-/merge_requests/10
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [ "./cmd/copyright" ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tctl \
      --bash <($out/bin/tctl completion bash) \
      --zsh <($out/bin/tctl completion zsh)
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command-line tool that you can use to interact with a Temporal Cluster";
    homepage = "https://docs.temporal.io/docs/system-tools/tctl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "tctl";
  };
}
