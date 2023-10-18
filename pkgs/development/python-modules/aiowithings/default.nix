{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, syrupy
, yarl
}:

buildPythonPackage rec {
  pname = "aiowithings";
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-withings";
    rev = "refs/tags/v${version}";
    hash = "sha256-YmTYwj3Udo1Pev25LLvY7757BR0h44aefqIe8b8FlTc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "aiowithings"
  ];

  meta = with lib; {
    description = "Module to interact with Withings";
    homepage = "https://github.com/joostlek/python-withings";
    changelog = "https://github.com/joostlek/python-withings/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
