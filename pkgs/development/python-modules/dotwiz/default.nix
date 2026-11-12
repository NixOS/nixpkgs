{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyheck,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dotwiz";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rnag";
    repo = "dotwiz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xeSACgyo670GJ40uOKFc9GnDZ1YY2wnBJAR16n1dr5E=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyheck ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dotwiz" ];

  disabledTestPaths = [ "benchmarks" ];

  meta = {
    description = "Dict subclass that supports dot access notation";
    homepage = "https://github.com/rnag/dotwiz";
    changelog = "https://github.com/rnag/dotwiz/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
