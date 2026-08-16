{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  woodpecker-plugin-git,
}:

buildGoModule (finalAttrs: {
  pname = "woodpecker-plugin-git";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    tag = finalAttrs.version;
    hash = "sha256-sXKR7DEcCVB6y2aHVB/57iacaijC4vLqV7/Mddrev48=";
  };

  vendorHash = "sha256-I3G3Skq7gltFEkL1gJDWTRlbKKnebW9zvoGGGKoQJuI=";

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
