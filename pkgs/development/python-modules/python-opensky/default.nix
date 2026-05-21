{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-opensky";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-opensky";
    tag = "v${version}";
    hash = "sha256-V6iRwWzCnPCvu8eks2sHPYrX3OmaFnNj+i57kQJKYm0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
    substituteInPlace src/python_opensky/opensky.py \
      --replace ".joinpath(uri)" "/ uri"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "python_opensky" ];

  meta = {
    description = "Asynchronous Python client for the OpenSky API";
    homepage = "https://github.com/joostlek/python-opensky";
    changelog = "https://github.com/joostlek/python-opensky/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
