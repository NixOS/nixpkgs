{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pydantic,
  pythonOlder,
  scrapy,
}:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pQiCQ+iO/jCY8XIIVecHF25zVa2H0dIOKwMpf10V0b4=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    attrs = [ attrs ];
    pydantic = [ pydantic ];
    scrapy = [ scrapy ];
  };

  # Infinite recursion with Scrapy
  doCheck = false;

  pythonImportsCheck = [ "itemadapter" ];

  meta = with lib; {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    changelog = "https://github.com/scrapy/itemadapter/raw/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
