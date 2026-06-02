{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ngxparse";
  version = "0.5.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M3RtFpPZOQOrDCs3uha4pHQ6J2exlZ3BJaJBfSU7fjs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ngxparse" ];

  meta = {
    description = "Reliable and fast NGINX configuration file parser (maintained fork of crossplane)";
    homepage = "https://github.com/dvershinin/crossplane";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dvershinin ];
  };
}
