{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pycryptodomex,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "gpsoauth";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCAu0wM5fSkntGTcleJxS///haGw+Iv2jzrWOFnr5DU=";
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
