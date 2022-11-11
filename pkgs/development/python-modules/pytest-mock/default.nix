{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytest
, pytest-asyncio
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.8.2";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d/A/RVQ5JVhwApXgWu0LEJaiDUpgpPPdzeWLDDHI/KI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [
    pytest
  ];

  checkInputs = [
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
