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
<<<<<<< HEAD
  version = "1.3.2";
=======
  version = "1.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "xk6";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5ZrkSYJlHRaEc8Quv2EoPAHp2Th9mE/Vi/scwPt/maE=";
=======
    hash = "sha256-t+zindC9mCYE5H/rqJ0AGB7alymYRNubDLQvkc5vZmo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
