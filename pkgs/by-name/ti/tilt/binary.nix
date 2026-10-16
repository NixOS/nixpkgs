{
  lib,
  buildGoModule,
  src,
  version,
  tilt-assets,
  stdenv,
  installShellFiles,
  nix-update,
  writeShellScript,
}:

buildGoModule rec {
  pname = "tilt";
  /*
    Do not use "dev" as a version. If you do, Tilt will consider itself
    running in development environment and try to serve assets from the
    source tree, which is not there once build completes.
  */
  inherit src version;

  vendorHash = null;

  subPackages = [ "cmd/tilt" ];

  ldflags = [ "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tilt \
      --bash <($out/bin/tilt completion bash) \
      --fish <($out/bin/tilt completion fish) \
      --zsh <($out/bin/tilt completion zsh)
  '';

  preBuild = ''
    mkdir -p pkg/assets/build
    cp -r ${tilt-assets}/* pkg/assets/build/
  '';

  passthru = {
    inherit tilt-assets;
    updateScript = writeShellScript "update-tilt" ''
      set -euo pipefail
      ${lib.getExe nix-update} "$@" --override-filename pkgs/by-name/ti/tilt/package.nix tilt
      ${lib.getExe nix-update} --version=skip --no-src tilt.tilt-assets
    '';
  };

  meta = {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    mainProgram = "tilt";
    homepage = "https://tilt.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      anton-dessiatov
      zacharyarnaise
    ];
  };
}
