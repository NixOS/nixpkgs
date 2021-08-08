{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5122bf4708a031b02db029366184a87c5d0ddd5a327a5884ee6cf0193e599d71";
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
