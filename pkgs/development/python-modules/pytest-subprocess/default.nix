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
  version = "1.4.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    rev = "refs/tags/${version}";
    hash = "sha256-8Of3/RltijfF5MXtVazGzIqpmRIhreT26kLNjzXLF1k=";
  };

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
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
