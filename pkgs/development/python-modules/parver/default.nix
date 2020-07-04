{ lib
, buildPythonPackage
, fetchPypi
, six
, attrs
, pytest
, hypothesis
, pretend
, arpeggio
}:

buildPythonPackage rec {
  pname = "parver";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a6jp17c1ag6b9yp5xgy9wvznk3g0v2f8gpwkcwxpyc9ygk98zdm";
  };

  propagatedBuildInputs = [ six attrs arpeggio ];
  checkInputs = [ pytest hypothesis pretend ];

  meta = {
    description = "parver allows parsing and manipulation of PEP 440 version numbers.";
    license = lib.licenses.mit;
  };
}
