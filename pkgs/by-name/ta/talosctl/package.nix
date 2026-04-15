{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "talosctl";
  version = "1.12.6";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eVA2ZRCC3Lw4EvSHi0ohEoRHudpAi+Ps4zcIfXQWlGE=";
  };

  vendorHash = "sha256-gul+sTsi0kVt8BGjuEAaqAnreDP9wql0dBOfMYuxRWY=";

  ldflags = [
    "-s"
    "-w"
  ];

  overrideModAttrs = _: {
    buildPhase = ''
      go work vendor
    '';
  };

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

  meta = {
    description = "CLI for out-of-band management of Kubernetes nodes created by Talos";
    mainProgram = "talosctl";
    homepage = "https://www.talos.dev/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      johanot
    ];
  };
})
