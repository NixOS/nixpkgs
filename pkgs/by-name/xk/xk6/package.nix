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
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "xk6";
    tag = "v${version}";
    hash = "sha256-+hWZWWrFkenzmaXAgzuZ9eWB4DmhQZNAQV+FYQdEg2U=";
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
