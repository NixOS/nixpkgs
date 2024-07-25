{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  pydantic,
  poetry-core,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pyaussiebb";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yaleman";
    repo = "aussiebb";
    rev = "refs/tags/v${version}";
    hash = "sha256-XNf9vYMlTLqhYIVNw9GjPcXpOm5EYCcC4aGukR8g3zc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    requests
    loguru
    pydantic
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requests = "^2.27.1"' 'requests = "*"'
  '';

  # Tests require credentials and requests-testing
  doCheck = false;

  pythonImportsCheck = [ "aussiebb" ];

  meta = with lib; {
    description = "Module for interacting with the Aussie Broadband APIs";
    homepage = "https://github.com/yaleman/aussiebb";
    changelog = "https://github.com/yaleman/pyaussiebb/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
