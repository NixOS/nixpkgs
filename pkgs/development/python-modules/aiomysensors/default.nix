{ lib
, aiofiles
, asyncio-mqtt
, awesomeversion
, buildPythonPackage
, click
, fetchFromGitHub
, marshmallow
, poetry-core
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiomysensors";
  version = "0.3.10";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-b462OZzRS9aldfJ+4ztczxbCMK76UM0pSOI1cIi1NM8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=src --cov-report=term-missing:skip-covered" "" \
      --replace 'marshmallow = "^3.17"' 'marshmallow = "*"' \
      --replace 'awesomeversion = "^22.6"' 'awesomeversion = "*"'
  '';
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "aiomysensors"
  ];

  meta = with lib; {
    description = "Library to connect to MySensors gateways";
    homepage = "https://github.com/MartinHjelmare/aiomysensors";
    changelog = "https://github.com/MartinHjelmare/aiomysensors/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
