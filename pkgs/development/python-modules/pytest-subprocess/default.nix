{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytest
, pytestCheckHook
, docutils
, pygments
, pytest-rerunfailures
, pytest-asyncio
, anyio
}:

buildPythonPackage rec {
  pname = "pytest-subprocess";
  version = "1.4.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    rev = version;
    hash = "sha256-xNkOXBCQ4AH/JVmxFzI3VSouA6jkCbUom7AdckfjGiE=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
    docutils
    pygments
    pytest-rerunfailures
    pytest-asyncio
    anyio
  ];

  meta = with lib; {
    description = "A plugin to fake subprocess for pytest";
    homepage = "https://github.com/aklajnert/pytest-subprocess";
    changelog = "https://github.com/aklajnert/pytest-subprocess/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
