{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "0.12.5";
in
rustPlatform.buildRustPackage {
  pname = "yek";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "bodo-run";
    repo = "yek";
    tag = "v${version}";
    hash = "sha256-QYsMk9fdCIFoPkd1j4bI5sb2tIEciWTvbxJql1sMJP4=";
  };
  cargoHash = "sha256-klNDUReMWW4dUNF7pE2lCpxJwskOnCgIdByDBpGpmrE=";

  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Serialize text files for LLM consumption";
    longDescription = ''
      Tool to read text-based files, chunk them, and serialize them for LLM consumption.
    '';
    homepage = "https://github.com/bodo-run/yek";
    changelog = "https://github.com/bodo-run/yek/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "yek";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
