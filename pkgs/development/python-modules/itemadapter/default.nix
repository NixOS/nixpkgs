{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d3WEhfsKwQcw1LExNj431ly42yRQv+x6V8PzJx9KSKk=";
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
