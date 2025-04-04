{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  woodpecker-plugin-git,
}:

buildGoModule rec {
  pname = "woodpecker-plugin-git";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    tag = version;
    hash = "sha256-8CioqP0+L4DMF3S7QOGAmq3Uj0WAi0W7jhw0HNWVPwQ=";
  };

  vendorHash = "sha256-X9cpR45fB4HqTn3TiehAw6J7G2lXAQ3OfxRh5N+ceFc=";

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
