{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  woodpecker-plugin-git,
}:

buildGoModule (finalAttrs: {
  pname = "woodpecker-plugin-git";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    tag = finalAttrs.version;
    hash = "sha256-MhtqRWmZCjtb2QOwlbnlZUPHDNunjgWlhHCtM9pvYMM=";
  };

  vendorHash = "sha256-hOktS+CQQ6TaHt96DaAcZXhqJGGleD/RdjdUfgv7oxw=";

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # Checks fail because they require network access.
  doCheck = false;

  passthru.tests.version = testers.testVersion { package = woodpecker-plugin-git; };

  meta = {
    description = "Woodpecker plugin for cloning Git repositories";
    homepage = "https://woodpecker-ci.org/";
    changelog = "https://github.com/woodpecker-ci/plugin-git/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "plugin-git";
    maintainers = with lib.maintainers; [
      ambroisie
      marcusramberg
    ];
  };
})
