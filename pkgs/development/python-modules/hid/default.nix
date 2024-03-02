{ lib
, buildPythonPackage
, fetchPypi
, hidapi
, nose
}:

buildPythonPackage rec {
  pname = "hid";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SNdk166XRroSO5bb9FeJPKgCaLd5HEsdLgUTEO64OGA=";
  };

  propagatedBuildInputs = [ hidapi ];

  nativeCheckInputs = [ nose ];

 postPatch = ''
    hidapi=${hidapi}/lib/
    test -d $hidapi || { echo "ERROR: $hidapi doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|libhidapi|$hidapi/libhidapi|" hid/__init__.py
  '';

  meta = with lib; {
    description = "hidapi bindings in ctypes";
    homepage = "https://github.com/apmorton/pyhidapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
