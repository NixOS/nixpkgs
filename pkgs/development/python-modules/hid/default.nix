{ lib
, buildPythonPackage
, fetchPypi
, hidapi
, nose
}:

buildPythonPackage rec {
  pname = "hid";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HpVOf3q5t8nfx421lQRpLBfbO3EklJK5drFSW5fbsOg=";
  };

  propagatedBuildInputs = [ hidapi ];

  checkInputs = [ nose ];

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
