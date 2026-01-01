{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "talosctl";
<<<<<<< HEAD
  version = "1.12.0";
=======
  version = "1.11.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-u8/T01PWBGH3bJCNoC+FIzp8aH05ci4Kr3eHHWPDRkI=";
  };

  vendorHash = "sha256-LLtbdKq028EEs8lMt3uiwMo2KMJ6nJKf6xFyLJlg+oM=";
=======
    hash = "sha256-53WZ1w7+FUhFY9YzfKcVle5Kjng+hlHuNn4klev+pqQ=";
  };

  vendorHash = "sha256-ocU7vpSdUdVzOFcqa+QWRdcP9SnC6WtV/ruheSGUfg4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  env.GOWORK = "off";

  subPackages = [ "cmd/talosctl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd talosctl \
      --bash <($out/bin/talosctl completion bash) \
      --fish <($out/bin/talosctl completion fish) \
      --zsh <($out/bin/talosctl completion zsh)
  '';

  doCheck = false; # no tests

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

<<<<<<< HEAD
  meta = {
    description = "CLI for out-of-band management of Kubernetes nodes created by Talos";
    mainProgram = "talosctl";
    homepage = "https://www.talos.dev/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ flokli ];
=======
  meta = with lib; {
    description = "CLI for out-of-band management of Kubernetes nodes created by Talos";
    mainProgram = "talosctl";
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
