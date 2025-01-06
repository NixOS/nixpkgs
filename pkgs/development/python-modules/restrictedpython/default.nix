{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-mock,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "restrictedpython";
  version = "7.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gbYpJHE9vSgJF/zq7K8hD+96Sd3fGgjIwhSjYT++tCU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" setuptools
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [ "test_compile__compile_restricted_exec__5" ];

  pythonImportsCheck = [ "RestrictedPython" ];

  meta = with lib; {
    description = "Restricted execution environment for Python to run untrusted code";
    homepage = "https://github.com/zopefoundation/RestrictedPython";
    changelog = "https://github.com/zopefoundation/RestrictedPython/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ juaningan ];
  };
}
