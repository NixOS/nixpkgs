{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pycryptodomex,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
}:

buildPythonPackage rec {
  pname = "gpsoauth";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BA+2aFxpFpi6cWGl4yepba7s7BmZ1ijvSBhtS23v3QM=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    poetry-core
  ];

  propagatedBuildInputs = [
    pycryptodomex
    requests
  ];

  pythonRelaxDeps = [ "urllib3" ];

  # upstream tests are not very comprehensive
  doCheck = false;

  pythonImportsCheck = [ "gpsoauth" ];

  meta = with lib; {
    description = "Library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };
}
