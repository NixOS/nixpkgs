{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  typioca,
}:

buildGoModule rec {
  pname = "typioca";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "typioca";
    rev = version;
    hash = "sha256-fViYwewzhJUJjMupCYk1UsnnPAhByYZqYkuKD6MJNnE=";
  };

  vendorHash = "sha256-fUkajuviQuQuVgzWAxsInd+c+eNQArKNjiNsi7mCNWU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bloznelis/typioca/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = typioca;
    };
  };

  meta = with lib; {
    description = "Cozy typing speed tester in terminal";
    homepage = "https://github.com/bloznelis/typioca";
    changelog = "https://github.com/bloznelis/typioca/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "typioca";
  };
}
