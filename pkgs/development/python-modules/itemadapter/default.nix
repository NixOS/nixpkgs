{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BbanndMaepk9+y6Dhqkcl+O4xs8otyVT6AjmJeC4fCA=";
  };

  # Infinite recursion with Scrapy
  doCheck = false;

  pythonImportsCheck = [
    "itemadapter"
  ];

  meta = with lib; {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    changelog = "https://github.com/scrapy/itemadapter/raw/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
