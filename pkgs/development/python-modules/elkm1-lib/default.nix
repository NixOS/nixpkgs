{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "elkm1-lib";
  version = "2.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "elkm1";
    rev = "refs/tags/${version}";
    hash = "sha256-z/ltpypCGJ3ORHOlLjicKlqIoxqGzVt588OHmNO65bg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    pyserial-asyncio
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "elkm1_lib"
  ];

  meta = with lib; {
    description = "Python module for interacting with ElkM1 alarm/automation panel";
    homepage = "https://github.com/gwww/elkm1";
    changelog = "https://github.com/gwww/elkm1/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
