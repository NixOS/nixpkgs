{ lib
, aiofiles
, aiohttp
, aioshutil
, buildPythonPackage
, dateparser
, fetchFromGitHub
, ipython
, orjson
, packaging
, pillow
, poetry-core
, py
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
, setuptools-scm
, termcolor
, typer
, ffmpeg
}:

buildPythonPackage rec {
  pname = "pyunifiprotect";
  version = "4.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5xHU4WC7HPDEJsfCX4bVsK3p6SWZ/fHH7APbFtDGC40=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=pyunifiprotect --cov-append" ""
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    aioshutil
    dateparser
    orjson
    packaging
    pillow
    pydantic
    pyjwt
    pytz
    typer
  ] ++ typer.optional-dependencies.all;

  passthru.optional-dependencies = {
    shell = [
      ipython
      python-dotenv
      termcolor
    ];
  };

  nativeCheckInputs = [
    ffmpeg # Required for command ffprobe
    py
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
    changelog = "https://github.com/AngellusMortis/pyunifiprotect/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
