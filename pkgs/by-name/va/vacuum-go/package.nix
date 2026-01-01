{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "vacuum-go";
<<<<<<< HEAD
  version = "0.21.7";
=======
  version = "0.20.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    # using refs/tags because simple version gives: 'the given path has multiple possibilities' error
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-eTwoK/AysxoTId6IM76b/euyYEE/9cwXcbDcm4wLjM0=";
  };

  vendorHash = "sha256-aTQEt1vBdzwOE99CHmCkodvGReR30Jq7iWkMtwK3620=";
=======
    hash = "sha256-nqsVX+fh+IzFCXx0my2/8lQGylCu+Cpb6ANnapC4kdg=";
  };

  vendorHash = "sha256-MAYm6qMNB9c6o4nSclVed4g9ToOjiAItTUMAsJgEBok=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  subPackages = [ "./vacuum.go" ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "vacuum version";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "World's fastest OpenAPI & Swagger linter";
    homepage = "https://quobix.com/vacuum";
    changelog = "https://github.com/daveshanley/vacuum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "vacuum";
    maintainers = with lib.maintainers; [ konradmalik ];
  };
})
