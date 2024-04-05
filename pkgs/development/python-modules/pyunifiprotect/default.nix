{ lib
, aiofiles
, aiohttp
, aioshutil
, async-timeout
, buildPythonPackage
, dateparser
, fetchFromGitHub
, ffmpeg
, hatch-vcs
, hatchling
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
, termcolor
, typer
}:

buildPythonPackage rec {
  pname = "pyunifiprotect";
  version = "4.23.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = "pyunifiprotect";
    rev = "refs/tags/v${version}";
    hash = "sha256-sBdu4XJkEtHf6dlHgJKFQvONp1x89NiS2EgxMiJFX7A=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--strict-markers -ra -Wd --ignore=.* --no-cov-on-fail --cov=pyunifiprotect --cov-append --maxfail=10 -n=auto" ""
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
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
  ] ++ typer.optional-dependencies.all
  ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

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
