{ lib
, aenum
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pydantic
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
, rich
}:

buildPythonPackage rec {
  pname = "intellifire4py";
  version = "4.1.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "intellifire4py";
    rev = "refs/tags/v${version}";
    hash = "sha256-dMhm2gntLV7ev6UIfHFMATytZo5blTlALuh9sBirkqI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aenum
    httpx
    pydantic
    rich
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "intellifire4py"
  ];

  meta = with lib; {
    description = "Module to read Intellifire fireplace status data";
    homepage = "https://github.com/jeeftor/intellifire4py";
    changelog = "https://github.com/jeeftor/intellifire4py/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
