{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "python-opensky";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-opensky";
    rev = "refs/tags/v${version}";
    hash = "sha256-62ncinv6XUGB1dYle/yqSCyJNbGD9BLaOqrF/zjL2fA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
    substituteInPlace src/python_opensky/opensky.py \
      --replace ".joinpath(uri)" "/ uri"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "python_opensky"
  ];

  meta = with lib; {
    description = "Asynchronous Python client for the OpenSky API";
    homepage = "https://github.com/joostlek/python-opensky";
    changelog = "https://github.com/joostlek/python-opensky/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
