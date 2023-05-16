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
<<<<<<< HEAD
  version = "4.20.0";
=======
  version = "4.8.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-d4pMswABy/KFO2adwufSRRsj879O894nphh3MEjZOl0=";
=======
    hash = "sha256-2DR1SPWElDZcTYF6TaJK3lxqJ5Skv76X+K+y6i69bj4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
