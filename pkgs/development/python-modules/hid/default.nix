{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hidapi,
}:

buildPythonPackage rec {
  pname = "hid";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XKEpp7lDSs5ePkKcEJKhZ5L+/68Geka2ZunFhocs3P4=";
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

  meta = with lib; {
    description = "Hidapi bindings in ctypes";
    homepage = "https://github.com/apmorton/pyhidapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
