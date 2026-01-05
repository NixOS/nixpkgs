{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
}:

buildGoModule rec {
  pname = "xk6";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "xk6";
    tag = "v${version}";
    hash = "sha256-uCjUzVDlqstHDvGEsXCkWgsUthrBM6MlK78IAEpogqU=";
  };

  vendorHash = null;

  subPackages = [ "cmd/xk6" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Build k6 with extensions";
    mainProgram = "xk6";
    homepage = "https://k6.io/";
    changelog = "https://github.com/grafana/xk6/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ szkiba ];
  };
}
