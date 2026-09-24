{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-qt,
  pyside6,
  versionCheckHook,
  which,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "plover-stroke";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover_stroke";
    tag = finalAttrs.version;
    hash = "sha256-A75OMzmEn0VmDAvmQCp6/7uptxzwWJTwsih3kWlYioA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-qt
    pyside6
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    which
  ];

  versionCheckProgramArg = "${placeholder "out"}/${python.sitePackages}";

  preInstallCheck = ''
    versionCheckProgram="$(which ls)"
  '';

  pythonImportsCheck = [ "plover_stroke" ];

  meta = {
    description = "Helper class for working with steno strokes";
    homepage = "https://github.com/openstenoproject/plover_stroke";
    license = lib.licenses.gpl2Plus; # https://github.com/openstenoproject/plover_stroke/issues/4
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
