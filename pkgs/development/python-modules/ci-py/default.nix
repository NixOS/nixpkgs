{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ci-py";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R/6bLsXOKGxiJDZUvvOuvLp3usEhfg698qvvgOwBXYk=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ci" ];

  meta = {
    description = "Library for working with Continuous Integration services";
    homepage = "https://github.com/grantmcconnaughey/ci.py";
    changelog = "https://github.com/grantmcconnaughey/ci.py/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
