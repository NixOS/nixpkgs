{
  lib,
  buildPythonPackage,
  dill,
  fetchPypi,
  pytest-freezegun,
  pytestCheckHook,
  python-utils,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/kjIlVqEQor3e/8mQrpHBB4bj3yGelt8yU+LwlWo8M8=";
  };

  postPatch = ''
    sed -i "/-cov/d" pytest.ini
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ python-utils ];

  nativeCheckInputs = [
    dill
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "progressbar" ];

  disabledTestPaths = [
    # Doesn't work in the sandbox
    "tests/test_readme_demos.py"
  ];

  meta = {
    description = "Text progressbar library";
    homepage = "https://progressbar-2.readthedocs.io/";
    changelog = "https://github.com/wolph/python-progressbar/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
