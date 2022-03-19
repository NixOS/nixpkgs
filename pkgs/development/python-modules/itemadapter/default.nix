{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.5.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BbanndMaepk9+y6Dhqkcl+O4xs8otyVT6AjmJeC4fCA=";
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
