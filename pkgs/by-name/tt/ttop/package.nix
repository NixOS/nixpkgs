{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  testers,
}:

buildNimPackage (finalAttrs: {
  pname = "ttop";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bBwSeB4azLjDTsfi9NFxoVphwUhHGFeJ/AYicYgk0as=";
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
    maintainers = with maintainers; [
      figsoda
      sikmir
    ];
    mainProgram = "ttop";
  };
})
