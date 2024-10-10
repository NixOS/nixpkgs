{ lib, buildNimPackage, fetchFromGitHub, testers }:

buildNimPackage (finalAttrs: {
  pname = "ttop";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/rs5JjTXxptVHXL3fY8qP6Be3r5N871CEbUH7w6zx4A=";
  };

  lockFile = ./lock.json;

  nimFlags = [
    "-d:NimblePkgVersion=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Top-like system monitoring tool";
    homepage = "https://github.com/inv2004/ttop";
    changelog = "https://github.com/inv2004/ttop/releases/tag/${finalAttrs.src.rev}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda sikmir ];
    mainProgram = "ttop";
  };
})
