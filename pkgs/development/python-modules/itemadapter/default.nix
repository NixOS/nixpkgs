{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.1.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "52159b4f97d82aa2968000ee8371b2114af56a2f44e4cd9142580d46eea39020";
  };

  doCheck = false; # infinite recursion with Scrapy

  pythonImportsCheck = [ "itemadapter" ];

  meta = with lib; {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
