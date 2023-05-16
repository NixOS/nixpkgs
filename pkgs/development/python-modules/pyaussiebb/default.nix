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
<<<<<<< HEAD
  version = "0.0.18";
=======
  version = "0.0.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yaleman";
    repo = "aussiebb";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-tEdddVsLFCHRvyLCctDakioiop2xWaJlfGE16P1ukHc=";
=======
    hash = "sha256-dbu26QFboqVaSFYlTXsOFA4yhXXNcB4QBCA8PZTphns=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/yaleman/pyaussiebb/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
