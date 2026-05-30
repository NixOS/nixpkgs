{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hidapi,
}:

buildPythonPackage rec {
  pname = "hid";
  version = "1.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9EcfEfDhdtGwyxskPlVJjMkDR6Ou3nNWVTBDlWlKwYI=";
  };

  postPatch = ''
    hidapi=${hidapi}/lib/
    test -d $hidapi || { echo "ERROR: $hidapi doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|libhidapi|$hidapi/libhidapi|" hid/__init__.py
  '';

  build-system = [ setuptools ];

  dependencies = [ hidapi ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "hid" ];

  meta = {
    description = "Hidapi bindings in ctypes";
    homepage = "https://github.com/apmorton/pyhidapi";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
}
