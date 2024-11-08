{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchPypi,
  setuptools,
  pandas,
  lxml,
  requests,
}:

buildPythonPackage rec {
  pname = "pandas-datareader";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.6" || pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fc3c63d39bc0c10c2683f1c6d503ff625020383e38f6cbe14134826b454d5a6";
  };

  build-system = [ setuptools ];

  dependencies = [
    pandas
    lxml
    requests
  ];

  # Tests are trying to load data over the network
  doCheck = false;
  pythonImportsCheck = [ "pandas_datareader" ];

  meta = with lib; {
    description = "Up to date remote data access for pandas, works for multiple versions of pandas";
    homepage = "https://github.com/pydata/pandas-datareader";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
