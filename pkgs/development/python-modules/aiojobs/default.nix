{ buildPythonPackage
, fetchPypi
, isPy27
, aiohttp
, pytest
, pytest-aiohttp
, pygments
, lib
}:

buildPythonPackage rec {
  pname = "aiojobs";
  version = "0.2.2";
  format = "flit";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "01a0msjh4w58fd7jplmblh0hwgpzwjs5xkgqz3d0p5yv3cykwjwf";
  };

  nativeBuildInputs = [
    pygments
  ];

  requiredPythonModules = [
    aiohttp
  ];

  checkInputs = [
    pytest
    pytest-aiohttp
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/aio-libs/aiojobs";
    description = "Jobs scheduler for managing background task (asyncio)";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
