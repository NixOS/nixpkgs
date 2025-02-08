{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pydantic,
  pythonOlder,
  scrapy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "itemadapter";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ow8n9MXi6K5BXYPj1g0zrbe6CbmMMGOLxgb7Hf8uzdI=";
  };

  build-system = [ setuptools ];

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
