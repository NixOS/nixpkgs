{ lib, fetchPypi, python3, ...}:

python3.pkgs.buildPythonPackage rec {
  pname = "aiohttp_client_cache";
  version = "0.11.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-B2b/9O2gVJjHUlN0pYeBDcwsy3slaAnd5SroeQqEU+s=";
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
