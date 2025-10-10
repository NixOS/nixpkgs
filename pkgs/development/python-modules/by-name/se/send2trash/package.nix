{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "send2trash";
  version = "1.8.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    tag = version;
    hash = "sha256-3RbKfluKOvl+sGJldtAt2bVfcasVKjCqVxmF6hVwh+Y=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Send file to trash natively under macOS, Windows and Linux";
    mainProgram = "send2trash";
    homepage = "https://github.com/hsoft/send2trash";
    changelog = "https://github.com/arsenetar/send2trash/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
