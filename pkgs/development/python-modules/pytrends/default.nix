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
  version = "4.9.0";
  disabled = isPy27; # python2 pandas is too old

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pU/B4xcUQrPI9cCApeId+Ae8T6rXeQzGK33bBZ6wqUs=";
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
