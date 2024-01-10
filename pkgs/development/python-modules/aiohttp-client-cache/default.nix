{ lib, fetchPypi, python3, ...}:

python3.pkgs.buildPythonPackage rec {
  pname = "aiohttp_client_cache";
  version = "0.10.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FXU4QNqa8B8ZADmoEyJfd8gsUDI0HEjIR9B2CBP55wU=";
  };
  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];
  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    attrs
    itsdangerous
    url-normalize
  ];
  meta = with lib; {
    description = "An async persistent cache for aiohttp requests";
    homepage = "https://pypi.org/project/aiohttp-client-cache/";
    license = licenses.mit;
    maintainers = with maintainers; [ seirl ];
  };
}
