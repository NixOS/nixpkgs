{
  lib,
  aiofiles,
  asyncio-mqtt,
  awesomeversion,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  marshmallow,
  poetry-core,
  pyserial-asyncio,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiomysensors";
  version = "0.3.16";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiomysensors";
    rev = "refs/tags/v${version}";
    hash = "sha256-1BpmjCgKiCZmBpBENlg79+I3UhkIxrgLAUD8ixpGUM8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=src --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    asyncio-mqtt
    awesomeversion
    click
    marshmallow
    pyserial-asyncio
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiomysensors" ];

  meta = with lib; {
    description = "Library to connect to MySensors gateways";
    homepage = "https://github.com/MartinHjelmare/aiomysensors";
    changelog = "https://github.com/MartinHjelmare/aiomysensors/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "aiomysensors";
  };
}
