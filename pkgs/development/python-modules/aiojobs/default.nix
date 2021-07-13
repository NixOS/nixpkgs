{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, aiohttp
, pytestCheckHook
, pytest-aiohttp
, pygments
}:

buildPythonPackage rec {
  pname = "aiojobs";
  version = "0.3.0";
  format = "flit";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9mMdQtxDCPfYg6u9cNTpdvP8w1o7oejq5dSvSUCh4MM=";
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

  pythonImportsCheck = [ "aiojobs" ];

  meta = with lib; {
    homepage = "https://github.com/aio-libs/aiojobs";
    description = "Jobs scheduler for managing background task (asyncio)";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
