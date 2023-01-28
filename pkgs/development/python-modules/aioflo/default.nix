{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioflo";
  version = "2021.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-7NrOoc1gi8YzZaKvCnHnzAKPlMnMhqxjdyZGN5H/8TQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioflo"
  ];

  meta = with lib; {
    description = "Python library for Flo by Moen Smart Water Detectors";
    homepage = "https://github.com/bachya/aioflo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
