{
  lib,
  buildPythonPackage,
  fetchPypi,
  flake8,
  six,
  pythonOlder,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "orderedmultidict";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BAcLu16HKRzJv6Ud9BNnf68hQcc8YdKl97Jr6jzYgq0=";
  };

  nativeCheckInputs = [ flake8 ];

  propagatedBuildInputs = [ six ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  meta = with lib; {
    description = "Ordered Multivalue Dictionary";
    homepage = "https://github.com/gruns/orderedmultidict";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vanzef ];
  };
}
