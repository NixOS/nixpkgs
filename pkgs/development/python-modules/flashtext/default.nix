{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "flashtext";
  version = "2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ob4rk+CdTw3u5KrXK5GnEnth+4uANMqanHjqdF2LBc8=";
  };

  # json files that tests look for don't exist in the pypi dist
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/vi3k6i5/flashtext";
    description = "Python package to replace keywords in sentences or extract keywords from sentences";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ mit ];
  };
}
