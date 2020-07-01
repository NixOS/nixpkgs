{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiofiles";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98e6bcfd1b50f97db4980e182ddd509b7cc35909e903a8fe50d8849e02d815af";
  };

  disabled = pythonOlder "3.3";

  # No tests in archive
  doCheck = false;

  meta = {
    description = "File support for asyncio";
    homepage = "https://github.com/Tinche/aiofiles";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
