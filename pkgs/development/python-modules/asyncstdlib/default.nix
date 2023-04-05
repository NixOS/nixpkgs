{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncstdlib";
  version = "3.10.6";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-JfKcmmusFmMckYc2+EBItt5V6o4Dk+foIv5hb7wMsHs=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "asyncstdlib"
  ];

  meta = with lib; {
    description = "Python library that extends the Python asyncio standard library";
    homepage = "https://asyncstdlib.readthedocs.io/";
    changelog = "https://github.com/maxfischer2781/asyncstdlib/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
