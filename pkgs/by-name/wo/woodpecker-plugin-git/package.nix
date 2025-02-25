{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  woodpecker-plugin-git,
}:

buildGoModule rec {
  pname = "woodpecker-plugin-git";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    tag = version;
    hash = "sha256-xE5wLW7u5fh+xk/D2Y+Fcx5eTiZX0pJYHKncWVwHDlQ=";
  };

  vendorHash = "sha256-XOriHt+qyOcuGZzMtGAZuztxLod92JzjKWWjNq5Giro=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Checks fail because they require network access.
  doCheck = false;

  passthru.tests.version = testers.testVersion { package = woodpecker-plugin-git; };

  meta = with lib; {
    description = "Woodpecker plugin for cloning Git repositories";
    homepage = "https://woodpecker-ci.org/";
    changelog = "https://github.com/woodpecker-ci/plugin-git/releases/tag/${version}";
    license = licenses.asl20;
    mainProgram = "plugin-git";
    maintainers = with maintainers; [ ambroisie ];
  };
}
