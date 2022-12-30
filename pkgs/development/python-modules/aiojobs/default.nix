{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiohttp
, pytestCheckHook
, pytest-aiohttp
, pygments
}:

buildPythonPackage rec {
  pname = "aiojobs";
  version = "1.1.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-FHdEVt/XXmuTrPAETyod3fHJIK1wg957/+QMAhZG1xk=";
  };

  nativeBuildInputs = [
    pygments
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytestCheckHook
    pytest-aiohttp
  ];

  pythonImportsCheck = [
    "aiojobs"
  ];

  meta = with lib; {
    description = "Jobs scheduler for managing background task (asyncio)";
    homepage = "https://github.com/aio-libs/aiojobs";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
