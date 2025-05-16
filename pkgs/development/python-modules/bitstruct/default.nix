{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.21.0";
  pyproject = true;

  build-system = [
    setuptools
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/wvklopFyvhojgdfVcyno/6SErBpumflsnsJJqEZSKw=";
  };

  pythonImportsCheck = [ "bitstruct" ];

  meta = with lib; {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
