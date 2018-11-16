{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e18138aecaa4a8f3b7ac7525b8466234e6378dd6cae702b982c9ed851d2ae21";
  };

  # No tests
  doCheck = false;

  meta = {
    description = "Diff JSON and JSON-like structures in Python";
    homepage = https://github.com/ZoomerAnalytics/jsondiff;
    license = lib.licenses.mit;
  };

}