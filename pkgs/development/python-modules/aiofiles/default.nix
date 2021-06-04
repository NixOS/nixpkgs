{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiofiles";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1c4fc9b2ff81568c83e21392a82f344ea9d23da906e4f6a52662764545e19d4";
    sha256 = "sha256-ocT8my/4FWjIPiE5KoLzROqdI9qQbk9qUmYnZFReGdQ=";
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
