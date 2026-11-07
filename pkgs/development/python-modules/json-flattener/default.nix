{
  lib,
  fetchPypi,
  buildPythonPackage,
  click,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json-flattener";
  version = "0.1.9";
  format = "setuptools";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "json_flattener";
    inherit version;
    hash = "sha256-hM+FIwRf+xJDAaYCYCIBZl/LADoXHs6H5vRu0C9/DBU=";
  };

  build-system = [ setuptools ];
  propagatedBuildInputs = [
    click
    pyyaml
  ];

  pythonImportsCheck = [ "json_flattener" ];

  meta = {
    description = "Flatten nested JSON documents into tables";
    homepage = "https://github.com/cmungall/json-flattener";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
