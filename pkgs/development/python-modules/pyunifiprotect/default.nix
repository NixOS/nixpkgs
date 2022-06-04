{ lib
, aiohttp
, aioshutil
, buildPythonPackage
, fetchFromGitHub
, ipython
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
, termcolor
, typer
}:

buildPythonPackage rec {
  pname = "pyunifiprotect";
  version = "3.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "briis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YFdGWGm+DUi/0l9YBliQH1VgpYEVcHVgLirJTrNmNP4=";
  };

  propagatedBuildInputs = [
    aiohttp
    aioshutil
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
    pytest-aiohttp
    pytest-asyncio
    pytest-benchmark
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
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
