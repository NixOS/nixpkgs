{
  lib,
  aiofiles,
  aiohttp,
  aioshutil,
  async-timeout,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  ffmpeg,
  hatch-vcs,
  hatchling,
  ipython,
  orjson,
  packaging,
  pillow,
  platformdirs,
  poetry-core,
  py,
  pydantic,
  pyjwt,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-benchmark,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
  pytz,
  termcolor,
  typer,
}:

buildPythonPackage rec {
  pname = "pyunifiprotect";
  version = "5.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = "pyunifiprotect";
    rev = "refs/tags/v${version}";
    hash = "sha256-DtQm6u3O0kdVJ23Ch+hJQ6HTOt5iAMdhCzC1K/oICWk=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--strict-markers -ra -Wd --ignore=.* --no-cov-on-fail --cov=pyunifiprotect --cov-append --maxfail=10 -n=auto" ""
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies =
    [
      aiofiles
      aiohttp
      aioshutil
      dateparser
      orjson
      packaging
      pillow
      platformdirs
      pydantic
      pyjwt
      pytz
      typer
    ]
    ++ typer.optional-dependencies.all
    ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

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

  pythonImportsCheck = [ "pyunifiprotect" ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  meta = with lib; {
    description = "Library for interacting with the Unifi Protect API";
    mainProgram = "unifi-protect";
    homepage = "https://github.com/briis/pyunifiprotect";
    changelog = "https://github.com/AngellusMortis/pyunifiprotect/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
