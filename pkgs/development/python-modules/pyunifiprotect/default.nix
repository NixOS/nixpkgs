{ lib
, aiohttp
, aioshutil
, buildPythonPackage
, fetchFromGitHub
, packaging
, pillow
, poetry-core
, pydantic
, pyjwt
, pytest-aiohttp
, pytest-asyncio
, pytest-benchmark
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, python-dotenv
, pythonOlder
, pytz
, typer
}:

buildPythonPackage rec {
  pname = "pyunifiprotect";
  version = "3.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0adbUKTkbgA4pKrIVFGowD4Wf8brjfkLpfCT/+Mw6vs=";
  };

  propagatedBuildInputs = [
    aiohttp
    aioshutil
    packaging
    pillow
    pydantic
    pyjwt
    python-dotenv
    pytz
    typer
  ];

  checkInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytest-benchmark
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/briis/pyunifiprotect/pull/176
    substituteInPlace setup.cfg \
      --replace "asyncio" "aiohttp"
    substituteInPlace pyproject.toml \
      --replace "--cov=pyunifiprotect --cov-append" ""
  '';

  pythonImportsCheck = [
    "pyunifiprotect"
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  disabledTests = [
    # Tests require ffprobe
    "test_get_camera_video"
  ];

  meta = with lib; {
    description = "Library for interacting with the Unifi Protect API";
    homepage = "https://github.com/briis/pyunifiprotect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
