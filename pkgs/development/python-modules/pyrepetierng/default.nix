{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrepetierng";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0+Qr2yrjk1/K4Yg55d8sdmI6BtBYI76DCQiPlp6dzrc=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyrepetierng" ];

  meta = {
    description = "An updated python Repetier-Server library based on Mtrabs library";
    homepage = "https://github.com/ShadowBr0ther/pyrepetier-ng";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
