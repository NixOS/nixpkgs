{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J5WETvB17IorjThcTVn16kiwjnGA/OPLJ4e+DbALH7Q=";
  };

  postPatch = ''
    sed -e "/'jsondiff=jsondiff.cli:main_deprecated',/d" -i setup.py
  '';

  # No tests
  doCheck = false;

  meta = {
    description = "Diff JSON and JSON-like structures in Python";
    homepage = "https://github.com/ZoomerAnalytics/jsondiff";
    license = lib.licenses.mit;
  };
}
