{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swtch";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "chitvs";
    repo = "swtch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xngUGPIW3HYtYAym/Qit5FjccSlYUGyeBHAomd3Aii0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Minimal terminal stopwatch";
    homepage = "https://github.com/chitvs/swtch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chitvs ];
    mainProgram = "swtch";
    platforms = lib.platforms.unix;
  };
})
