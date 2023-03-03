{ lib
, aiohttp
, aioresponses
, pydantic
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioopenexchangerates";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qm9B4m5CLhfqnZj+sdHZ+iA0+YnDR9Dh3lCy/YADkEI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=aioopenexchangerates --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "aioopenexchangerates"
  ];

  meta = with lib; {
    description = "Library for the Openexchangerates API";
    homepage = "https://github.com/MartinHjelmare/aioopenexchangerates";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
