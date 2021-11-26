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
  version = "1.0.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "EQwD0b2B9qFVd/8thKInaio0hpPzvVIjvCN0TcARu2w=";
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
