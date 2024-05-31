{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hidapi,
}:

buildPythonPackage rec {
  pname = "hid";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SNdk166XRroSO5bb9FeJPKgCaLd5HEsdLgUTEO64OGA=";
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
    description = "hidapi bindings in ctypes";
    homepage = "https://github.com/apmorton/pyhidapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
