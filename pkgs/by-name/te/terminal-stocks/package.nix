{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "terminal-stocks";
  version = "1.0.19";

  src = fetchFromGitHub {
    owner = "shweshi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6eDBcQfo6M+Z31ILLM4BbiOxoTD6t4LQJxawoJFEzhg=";
  };

  npmDepsHash = "sha256-0k2+vdfOUF0zV6Tl7VGXS2dNLnCHgSdI12LqvGkbv+k=";
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Terminal based application that provides stock price information";
    homepage = "https://github.com/shweshi/terminal-stocks";
    maintainers = with maintainers; [ mislavzanic ];
    license = licenses.mit;
    mainProgram = "terminal-stocks";
  };
}
