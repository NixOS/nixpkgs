{
  buildGoModule,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "tanka";
  version = "0.39.4";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tanka";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-C0OBEANOaNC1AnVLFZ4lsRWqBNMEBaAz4uRL2+aUJLs=";
  };

  vendorHash = "sha256-OuQrbyjQiJTuveffebShMRqnSgHNW7A+iTw+O1z3qjY=";

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

  meta = {
    description = "Flexible, reusable and concise configuration for Kubernetes";
    homepage = "https://tanka.dev";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "tk";
  };
})
