{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  testers,
}:

buildNimPackage (finalAttrs: {
  pname = "ttop";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JdUoVP/R3epkx53kMdIflDEuFuJRzCxQY1BgsyVItqM=";
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

  meta = {
    description = "Top-like system monitoring tool";
    homepage = "https://github.com/inv2004/ttop";
    changelog = "https://github.com/inv2004/ttop/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sikmir
    ];
    mainProgram = "ttop";
  };
})
