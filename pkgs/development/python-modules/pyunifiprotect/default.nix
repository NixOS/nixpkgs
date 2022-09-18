{ lib
, aiofiles
, aiohttp
, aioshutil
, buildPythonPackage
, fetchFromGitHub
, ipython
, orjson
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
, setuptools
, termcolor
, typer
, ffmpeg
}:

buildPythonPackage rec {
  pname = "pyunifiprotect";
  version = "4.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DBOPHeSEdM6cev2BZs1AwXmzNPVsekNklu9c+KhECiI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=pyunifiprotect --cov-append" ""
    substituteInPlace setup.cfg \
      --replace "pydantic!=1.9.1" "pydantic"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    aioshutil
    orjson
    packaging
    pillow
    pydantic
    pyjwt
    pytz
    typer
  ];

  passthru.optional-dependencies = {
    shell = [
      ipython
      python-dotenv
      termcolor
    ];
  };

  checkInputs = [
    ffmpeg # Required for command ffprobe
    pytest-aiohttp
    pytest-asyncio
    pytest-benchmark
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyunifiprotect"
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  meta = with lib; {
    description = "Library for interacting with the Unifi Protect API";
    homepage = "https://github.com/briis/pyunifiprotect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
