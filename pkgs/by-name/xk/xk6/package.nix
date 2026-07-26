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
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "xk6";
    tag = "v${version}";
    hash = "sha256-ZJJlwP3jI8/J8XIg2oqtPY5Bojm7xuYCnBJ7B+qbDSU=";
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
