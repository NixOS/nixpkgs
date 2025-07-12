{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  html5lib,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HeqUf5vn6gq2EPe7xKTja0XWv9/O6imtPTiaiKGVfd8=";
  };

  patches = [
    (fetchpatch {
      name = "fix-cookietests-python3.13.patch";
      url = "https://github.com/python-mechanize/mechanize/commit/0c1cd4b65697dee4e4192902c9a2965d94700502.patch";
      hash = "sha256-Xlx8ZwHkFbJqeWs+/fllYZt3CZRu9rD8bMHHPuUlRv4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ html5lib ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mechanize" ];

  disabledTestPaths = [
    # Tests require network access
    "test/test_urllib2_localnet.py"
    "test/test_functional.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_pickling"
    "test_password_manager"
  ];

  meta = with lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    changelog = "https://github.com/python-mechanize/mechanize/blob/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
