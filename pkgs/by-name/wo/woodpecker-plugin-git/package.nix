{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  woodpecker-plugin-git,
}:

buildGoModule rec {
  pname = "woodpecker-plugin-git";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    tag = version;
    hash = "sha256-iCB2GQ8SpuW+uT8RyMNb6cq4bbWIeMO069yq4a+nIVI=";
  };

  vendorHash = "sha256-Zn2TYNyKvtmtEAlKmWBhjyzHiM0dwDT3E/LOtSzjFK0=";

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
