{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  setuptools,
  pandas,
  lxml,
  requests,
}:

buildPythonPackage rec {
  pname = "pandas-datareader";
  version = "0.11.1";
  pyproject = true;

  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4erbbSzKpLeodqHIG2/wMH+noItW93mYYqUCB8LmWgU=";
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

  meta = {
    description = "Up to date remote data access for pandas, works for multiple versions of pandas";
    homepage = "https://github.com/pydata/pandas-datareader";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evax ];
    platforms = lib.platforms.unix;
  };
}
