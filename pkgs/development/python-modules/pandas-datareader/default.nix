{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, isPy27
, pandas
, lxml
, requests
}:

buildPythonPackage rec {
  pname = "pandas-datareader";
  version = "0.9.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2cbc1e16a6ab9ff1ed167ae2ea92839beab9a20823bd00bdfb78155fa04f891";
  };

  # Tests are trying to load data over the network
  doCheck = false;
  pythonImportsCheck = [ "pandas_datareader" ];

  propagatedBuildInputs = [ pandas lxml requests ];

  meta = with stdenv.lib; {
    description = "Up to date remote data access for pandas, works for multiple versions of pandas";
    homepage = "https://github.com/pydata/pandas-datareader";
    license= licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
