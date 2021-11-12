{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.4.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f05df8da52619da4b8c7f155d8a15af19083c0c7ad941d8c1de799560ad994ca";
  };

  doCheck = false; # infinite recursion with Scrapy

  pythonImportsCheck = [ "itemadapter" ];

  meta = with lib; {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    changelog = "https://github.com/scrapy/itemadapter/raw/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
