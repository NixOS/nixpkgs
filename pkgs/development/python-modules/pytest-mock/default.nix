{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, pytest
, pytest-asyncio
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.12.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MaQPA4wiytMih7tDkyBURR/1WD/wlLym9nXfL4vBpuk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  meta = with lib; {
    description = "Thin wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    changelog = "https://github.com/pytest-dev/pytest-mock/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
