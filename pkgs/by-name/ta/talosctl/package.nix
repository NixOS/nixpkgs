{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "talosctl";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    tag = "v${version}";
    hash = "sha256-j/GqAUP3514ROf64+ouvCg//9QuGoVDgxkNFqi4r+WE=";
  };

  vendorHash = "sha256-XvOMNyiHnemqnbOzWmzZXkr3+/ZgJDg8vjCtWFkCtLs=";

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
