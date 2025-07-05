{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocamlPackages,
  versionCheckHook,
  unstableGitUpdater,
}:
buildDunePackage {
  pname = "zbg";
  version = "0-unstable-2024-01-04";

  src = fetchFromGitHub {
    owner = "chshersh";
    repo = "zbg";
    rev = "9fa381bd0301027e5ac25ef157b6c0075c00f6f2";
    hash = "sha256-oWxUaxWSF46uMcPAnR6PWI8Xf4cQkoYyeRdWN7GOcE0=";
  };

  minimalOCamlVersion = "3.7";

  buildInputs = with ocamlPackages; [
    ansiterminal
    core
    core_unix
    ppx_assert
    ppx_deriving
    ppx_inline_test
    ppx_jane
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Zero Bullshit Git";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "zbg";
  };
}
