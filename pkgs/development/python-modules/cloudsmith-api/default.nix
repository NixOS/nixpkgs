{
  lib,
  buildPythonPackage,
  certifi,
  fetchPypi,
  python-dateutil,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cloudsmith-api";
  version = "2.0.22";
  format = "wheel";

  src = fetchPypi {
    pname = "cloudsmith_api";
    inherit format version;
    hash = "sha256-FZcDjrK5+oHC3dVBSXf+txW6hofP6OkmkjO4NJF05YQ=";
  };

  propagatedBuildInputs = [
    certifi
    python-dateutil
    six
    urllib3
  ];

  # Wheels have no tests
  doCheck = false;

  pythonImportsCheck = [ "cloudsmith_api" ];

  meta = {
    description = "Cloudsmith API Client";
    homepage = "https://github.com/cloudsmith-io/cloudsmith-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ usertam ];
  };
}
