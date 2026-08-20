{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vercel-fx";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "fx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NeDAx55Ws3pZJeug8rYEFQaMI2Kf1Smz07nwhhiL+WM=";
  };

  nativeBuildInputs = [ zig_0_16.hook ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Coding agent harness and CLI";
    homepage = "https://github.com/vercel-labs/fx";
    changelog = "https://github.com/vercel-labs/fx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "fx";
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
})
