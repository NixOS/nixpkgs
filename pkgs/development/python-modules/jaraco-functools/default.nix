{
  lib,
  buildPythonPackage,
  fetchPypi,
  more-itertools,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "jaraco-functools";
  version = "4.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jaraco_functools";
    inherit version;
    hash = "sha256-cPfg4q4HZJjiElYjJegFIE/Akte0wX4OhslZ4klwGp0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ more-itertools ];

  doCheck = false;

  pythonNamespaces = [ "jaraco" ];

  pythonImportsCheck = [ "jaraco.functools" ];

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    license = licenses.mit;
    maintainers = [ ];
  };
}
