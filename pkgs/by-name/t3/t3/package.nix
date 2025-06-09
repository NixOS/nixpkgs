{
  fetchFromGitHub,
  help2man,
  lib,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "t3";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "flox";
    repo = "t3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-42T0qQ3zK1jTRU+gcBzEet5rHZ6QuknCbPdbGPNlETI=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${finalAttrs.version}"
  ];
  nativeBuildInputs = [ help2man ];
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next generation tee with colorized output streams and precise time stamping";
    homepage = "https://github.com/flox/t3";
    changelog = "https://github.com/flox/t3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ limeytexan ];
    platforms = lib.platforms.unix;
    mainProgram = "t3";
  };
})
