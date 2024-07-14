{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  typing ? null,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiohttp-cors";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TTnG1xAP2XZO0cr4zr8OsBv14/JOLgc/2mI0vEixn10=";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [ aiohttp ] ++ lib.optional (pythonOlder "3.5") typing;

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "CORS support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-cors";
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };
}
