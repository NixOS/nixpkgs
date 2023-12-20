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
  version = "3.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ovJUL8Z98F6gyKG04CoOiQE5dJbp9yTVHcTgniJBvOw=";
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

  pythonImportsCheck = [
    "intellifire4py"
  ];
  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Module to read Intellifire fireplace status data";
    homepage = "https://github.com/jeeftor/intellifire4py";
    changelog = "https://github.com/jeeftor/intellifire4py/blob/${version}/CHANGELOG";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
