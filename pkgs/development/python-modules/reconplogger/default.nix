{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  logmatic-python,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyyaml,
  requests,
  setuptools,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "reconplogger";
<<<<<<< HEAD
  version = "4.18.1";
  pyproject = true;

=======
  version = "4.18.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "reconplogger";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kYNidF1sTC6WulX3HXMUm+TFJWvHgZj86Asmi6uIKRs=";
=======
    hash = "sha256-awUGDE9yuPhWMZ4osCJKw8v5V1leoFF3DeCbluHeN70=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    logmatic-python
    pyyaml
  ];

  optional-dependencies = {
    all = [
      flask
      requests
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [ "reconplogger" ];

  enabledTestPaths = [ "reconplogger_tests.py" ];

<<<<<<< HEAD
  meta = {
    description = "Module to ease the standardization of logging within omni:us";
    homepage = "https://github.com/omni-us/reconplogger";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module to ease the standardization of logging within omni:us";
    homepage = "https://github.com/omni-us/reconplogger";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
