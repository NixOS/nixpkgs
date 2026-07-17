{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termsnap";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tomcur";
    repo = "termsnap";
    rev = "termsnap-v${finalAttrs.version}";
    hash = "sha256-bYqhrMmgkEAiA1eiDbIOwH/PktwtIfxmYJRwDrFsNIc=";
  };

  cargoHash = "sha256-lfWQ7VzFYhbEjrhKxPT8quhxbL+5pTzIPUVjBBHRk7Q=";

  meta = {
    description = "Create SVGs from terminal output";
    homepage = "https://github.com/tomcur/termsnap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yash-garg ];
    mainProgram = "termsnap";
  };
})
