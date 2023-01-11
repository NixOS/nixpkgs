{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, pytest
, pytest-localserver
, requests
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-base-url";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-v6pLejWNeb9Do6x2EJqmLKj8DNqcMtmYIs+7iDYsbjk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    pytest-localserver
  ];

  pytestFlagsArray = [
    "tests"
  ];

  pythonImportsCheck = [
    "pytest_base_url"
  ];

  meta = with lib; {
    description = "pytest plugin for URL based tests";
    homepage = "https://github.com/pytest-dev/pytest-base-url";
    changelog = "https://github.com/pytest-dev/pytest-base-url/blob/v${version}/CHANGES.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ sephi ];
  };
}
