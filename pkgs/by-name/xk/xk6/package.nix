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
  version = "1.4.14";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "xk6";
    tag = "v${version}";
    hash = "sha256-sA3b1EUczciQV9jrVR2YkjuW0i1LOIHctLJWK2q8po0=";
  };

  vendorHash = null;

  subPackages = [ "cmd/xk6" ];

  ldflags = [ "-X go.k6.io/xk6/internal/cmd.version=${version}" ];

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
