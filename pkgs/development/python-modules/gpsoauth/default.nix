{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pycryptodomex,
  requests,
}:

buildPythonPackage rec {
  pname = "gpsoauth";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6gbP6uMqc5HIeKsdJ1wCTAfDwyvFmbKf0o+AyCsxODU=";
  };

  nativeBuildInputs = [
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

  meta = {
    description = "Library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jgillich ];
  };
}
