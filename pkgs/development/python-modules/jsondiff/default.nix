{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsondiff";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00v3689175aqzdscrxpffm712ylp8jvcpqdg51ca22ni6721p51l";
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
