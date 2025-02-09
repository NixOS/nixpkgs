{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, ciso8601
, click
, fetchFromGitHub
, mashumaro
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "aiortm";
  version = "0.8.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiortm";
    rev = "refs/tags/v${version}";
    hash = "sha256-rWULiyQGBA01hWfRDulDuHX0c1LPo6CTZ9HFOn3MD+E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=aiortm --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    ciso8601
    click
    mashumaro
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiortm"
  ];

  meta = with lib; {
    description = "Library for the Remember the Milk API";
    homepage = "https://github.com/MartinHjelmare/aiortm";
    changelog = "https://github.com/MartinHjelmare/aiortm/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
