{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "prosemirror-rs";
  version = "0.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fiduswriter";
    repo = "prosemirror-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jw7074y39egW8P4p0Tx4UA5upbsy4zM3vrjf+NJsNLE=";
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  preBuild = ''
    cd python
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python bindings for ProseMirror";
    homepage = "https://github.com/fiduswriter/prosemirror-rs";
    mainProgram = "prosemirror-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
