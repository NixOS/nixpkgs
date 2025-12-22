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
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vtnvAOO8sE8MhHjxH96+Y+v0W6z/6AJxnfsHDpadIGI=";
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

  meta = {
    description = "Common interface for data container classes";
    homepage = "https://github.com/scrapy/itemadapter";
    changelog = "https://github.com/scrapy/itemadapter/raw/v${version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
