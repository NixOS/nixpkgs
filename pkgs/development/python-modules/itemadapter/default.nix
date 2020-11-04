{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.1.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5e75d48c769ee5c89de12aeba537b2d62d7b575cd549d5d430ed8a67faa63f2";
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
