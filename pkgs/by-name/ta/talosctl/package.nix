{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "talosctl";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    rev = "v${version}";
    hash = "sha256-qZJN3LZfpL/uaq9H47m4qddF7ZxXLAHHVDUaRuldoBw=";
  };

  vendorHash = "sha256-8mcxWIHnMFJ/jKzy2YJz+IvI3kb+waaI6Sxjrirh5zg=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.GOWORK = "off";

  subPackages = [ "cmd/talosctl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd talosctl \
      --bash <($out/bin/talosctl completion bash) \
      --fish <($out/bin/talosctl completion fish) \
      --zsh <($out/bin/talosctl completion zsh)
  '';

  doCheck = false; # no tests

  meta = with lib; {
    description = "CLI for out-of-band management of Kubernetes nodes created by Talos";
    mainProgram = "talosctl";
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}
