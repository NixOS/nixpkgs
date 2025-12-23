{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  typioca,
}:

buildGoModule (finalAttrs: {
  pname = "typioca";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "typioca";
    tag = "${finalAttrs.version}";
    hash = "sha256-fViYwewzhJUJjMupCYk1UsnnPAhByYZqYkuKD6MJNnE=";
  };

  vendorHash = "sha256-fUkajuviQuQuVgzWAxsInd+c+eNQArKNjiNsi7mCNWU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bloznelis/typioca/cmd.Version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = typioca;
    };
  };

  meta = {
    description = "Cozy typing speed tester in terminal";
    homepage = "https://github.com/bloznelis/typioca";
    changelog = "https://github.com/bloznelis/typioca/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "typioca";
  };
})
