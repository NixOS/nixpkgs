{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "talosctl";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    tag = "v${version}";
    hash = "sha256-nI+6EzbGQzfM/pG4d5O4I5BEJ2aNaZ/sE28/EcgQmCs=";
  };

  vendorHash = "sha256-o/PYWR7KOWCVXUhzdPY0bxRhCROXzp/UAXgFkWpggC8=";

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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = with lib; {
    description = "CLI for out-of-band management of Kubernetes nodes created by Talos";
    mainProgram = "talosctl";
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}
