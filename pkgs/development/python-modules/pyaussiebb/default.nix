{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, loguru
, pydantic
, poetry-core
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyaussiebb";
  version = "0.0.13";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yaleman";
    repo = "aussiebb";
    rev = "v${version}";
    hash = "sha256-8DX7GwSnpiqUO20a6oLMMTkpTUxWTb8LMD4Uk0lyAOY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

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

  pythonImportsCheck = [
    "aussiebb"
  ];

  meta = with lib; {
    description = "Module for interacting with the Aussie Broadband APIs";
    homepage = "https://github.com/yaleman/aussiebb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
