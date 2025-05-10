{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.20.0";
  pyproject = true;

  build-system = [
    setuptools
  ];

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9rFqkwlzE/KmwUZkDJPl+YijnDM2T4wgpChqwcXtXa4=";
  };

  pythonImportsCheck = [ "bitstruct" ];

  meta = with lib; {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
