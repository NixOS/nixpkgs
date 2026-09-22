{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  withQemu ? false,
  qemu,
}:

buildGoModule (finalAttrs: {
  pname = "talosctl";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-55BnNQAUxzUbtYjvMAM6ExnDPNyl7XN7pASYBeMWt3Y=";
  };

  vendorHash = "sha256-2mhMSfw3YMO5Tg3b14DIFtJiGFdXaDSaJ4XoR6PXdHA=";

  postPatch = lib.optionalString withQemu ''
    substituteInPlace pkg/provision/providers/qemu/arch.go \
      --replace-fail '/opt/homebrew' '${lib.getLib qemu}'
  '';

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

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals withQemu [ makeWrapper ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd talosctl \
        --bash <($out/bin/talosctl completion bash) \
        --fish <($out/bin/talosctl completion fish) \
        --zsh <($out/bin/talosctl completion zsh)
    ''
    + lib.optionalString withQemu ''
      wrapProgram $out/bin/talosctl \
        --suffix PATH : ${lib.makeBinPath [ qemu ]}
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
