{
  buildGoModule,
  fetchFromGitHub,
  lib,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tanka";
  version = "0.40.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tanka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xJUEVYZvSbTNKqB0jO17cSO7ndsih8qsiFZ1NcJLlXU=";
  };

  vendorHash = "sha256-X0rPhhZUJ5slXsEII/w0iRIBKLuBKVTDOQCExQyyh9A=";

  doCheck = false;
  # Required for versions >= 0.28 as they introduce a gowork.sum file. This is only used for tests so we can safely disable GOWORK
  env.GOWORK = "off";

  subPackages = [ "cmd/tk" ];

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
    "-X github.com/grafana/tanka/pkg/tanka.CurrentVersion=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    echo "complete -C $out/bin/tk tk" > tk.bash

    cat >tk.fish <<EOF

    function __complete_tk
        set -lx COMP_LINE (commandline -cp)
        test -z (commandline -ct)
        and set COMP_LINE "\$COMP_LINE "
        $out/bin/tk
    end
    complete -f -c tk -a "(__complete_tk)"

    EOF

    cat >tk.zsh <<EOF
    #compdef tk
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C $out/bin/tk tk
    EOF

    installShellCompletion \
      --cmd tk \
      --bash tk.bash \
      --fish tk.fish \
      --zsh tk.zsh
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flexible, reusable and concise configuration for Kubernetes";
    homepage = "https://tanka.dev";
    changelog = "https://github.com/grafana/tanka/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "tk";
  };
})
