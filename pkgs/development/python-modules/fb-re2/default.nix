{ lib
, buildPythonPackage
, fetchPypi
, re2
}:

buildPythonPackage rec {
  pname = "fb-re2";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83b2c2cd58d3874e6e3a784cf4cf2f1a57ce1969e50180f92b010eea24ef26cf";
  };

  buildInputs = [ re2 ];

  # no tests in PyPI tarball
  doCheck = false;

  meta = {
    description = "Python wrapper for Google's RE2";
    homepage = https://github.com/facebook/pyre2;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
