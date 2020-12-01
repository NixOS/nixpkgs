{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pydata-sphinx-theme";
  version = "0.4.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e95d0dca0a64ba9471a89cdb6197cf8bb81b31f75ad0b7b6f0e85196fb7fe39";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  meta = with lib; {
    description = "Bootstrap-based Sphinx theme from the PyData community";
    homepage = https://github.com/pandas-dev/pydata-sphinx-theme;
    license = licenses.bsd3;
  };
}