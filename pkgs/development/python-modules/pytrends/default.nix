{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, requests
, lxml
, pandas
}:

buildPythonPackage rec {
  pname = "pytrends";
  version = "4.7.3";
  disabled = isPy27; # python2 pandas is too old

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ccb06c57c31fa157b978a0d810de7718ee46583d28cf818250d45f36abd2faa";
  };

  propagatedBuildInputs = [ requests lxml pandas ];

  doCheck = false;
  pythonImportsCheck = [ "pytrends" ];

  meta = with lib; {
    description = "Pseudo API for Google Trends";
    homepage = "https://github.com/GeneralMills/pytrends";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mmahut ];
  };

}
