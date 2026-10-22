{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  woodpecker-plugin-git,
}:

buildGoModule (finalAttrs: {
  pname = "woodpecker-plugin-git";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    tag = finalAttrs.version;
    hash = "sha256-5LcIs+EFKfS5vutRsT+X34XawX+AHdkEych6Sn4hJaM=";
  };

  vendorHash = "sha256-d9FbboPtqh856zcsDOvm3uzLUsU7PuvaUiO1/U1kooM=";

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
