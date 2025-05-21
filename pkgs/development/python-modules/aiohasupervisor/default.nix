{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchPypi,
  mashumaro,
  orjson,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiohasupervisor";
  version = "0.1.0b0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ocvNDLZ6h4PincCHhZfKEsIvQH0LScAsY3zrfDsXWHI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=68.0.0" "setuptools>=68.0.0" \
      --replace-fail "wheel~=0.40.0" "wheel>=0.40.0"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  # Import issue, check with next release
  doCheck = false;

  pythonImportsCheck = [ "aiohasupervisor" ];

  meta = {
    description = "Client for Home Assistant Supervisor";
    homepage = "https://pypi.org/project/aiohasupervisor/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
