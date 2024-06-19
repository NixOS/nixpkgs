{ buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, lib
, cachetools
}:


buildPythonPackage rec {
  pname = "asyncache";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mh5gp1Zo55RldIm96mVA7n4yWcSDUXuTRnDbdgC/UDU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    cachetools
  ];

  meta = with lib; {
    description = "Helpers to use cachetools with async code";
    homepage = "https://pypi.org/project/asyncache/";
    license = licenses.mit;
  };
}
