{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  aiohttp,
  poetry-core,
  yarl,
  aresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ambee";
  version = "0.4.0";
  disabled = pythonOlder "3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-ambee";
    rev = "v${version}";
    hash = "sha256-2wX2CLr6kdVw2AGPW6DmYI2OBfQFI/iWVorok2d3wx4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  pythonImportsCheck = [ "ambee" ];

  meta = with lib; {
    description = "Python client for Ambee API";
    homepage = "https://github.com/frenck/python-ambee";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
