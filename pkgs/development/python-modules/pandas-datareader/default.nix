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
    hash = "sha256-n8PGPTm8DBDCaD8cbVA/9iUCA4Pjj2y+FBNIJrRU1aY=";
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
