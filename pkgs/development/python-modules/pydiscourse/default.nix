{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "pydiscourse";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydiscourse";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BvVKOfc/PiAnkEnH5jsd8/0owr+ZvJIz/tpZx6K0fP0=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "pydiscourse"
  ];

  meta = with lib; {
    description = "A Python library for working with Discourse";
    homepage = "https://github.com/pydiscourse/pydiscourse";
    changelog = "https://github.com/pydiscourse/pydiscourse/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Dettorer ];
  };
}
