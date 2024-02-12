{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, prompt-toolkit
, pycryptodome
, pydantic
, pythonOlder
, pythonRelaxDepsHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pykoplenti";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stegm";
    repo = "pykoplenti";
    rev = "refs/tags/v${version}";
    hash = "sha256-2sGkHCIGo1lzLurvQBmq+16sodAaK8v+mAbIH/Gd3+E=";
  };

  pythonRelaxDeps = [
    "pydantic"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    pycryptodome
    pydantic
  ];

  passthru.optional-dependencies = {
    CLI = [
      click
      prompt-toolkit
    ];
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pykoplenti"
  ];

  meta = with lib; {
    description = "Python REST client API for Kostal Plenticore Inverters";
    homepage = "https://github.com/stegm/pykoplenti/";
    changelog = "https://github.com/stegm/pykoplenti/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
