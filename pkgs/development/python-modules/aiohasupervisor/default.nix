{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-supervisor-client";
    tag = version;
    hash = "sha256-72YRaTlgRJ8liQ1q+Hx1iCG8Av7wWk61t306fYT9gss=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"' \
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
    changelog = "https://github.com/home-assistant-libs/python-supervisor-client/releases/tag/${src.tag}";
    description = "Client for Home Assistant Supervisor";
    homepage = "https://github.com/home-assistant-libs/python-supervisor-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
