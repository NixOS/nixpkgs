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
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jzyylcmjxb0agc4fpdnzdnv2ajvp99rs9pz7qcklnhlmy8scdqv";
  };

  propagatedBuildInputs = [ six attrs arpeggio ];
  checkInputs = [ pytest hypothesis pretend ];

  meta = {
    description = "parver allows parsing and manipulation of PEP 440 version numbers.";
    license = lib.licenses.mit;
  };
}
