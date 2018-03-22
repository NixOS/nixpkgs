{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d0437782de9418efa34e694aa59f43d7adb1899bd9a793f063867ddba8f7893";
  };

  # No tests
  doCheck = false;

  meta = {
    description = "Diff JSON and JSON-like structures in Python";
    homepage = https://github.com/ZoomerAnalytics/jsondiff;
    license = lib.licenses.mit;
  };

}