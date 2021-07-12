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
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c902e0653bcce927cc156a7fd9b3a51924cbce3bf3d0bfd49fc282bfd0c5dfd3";
  };

  propagatedBuildInputs = [ six attrs arpeggio ];
  checkInputs = [ pytest hypothesis pretend ];

  meta = {
    description = "parver allows parsing and manipulation of PEP 440 version numbers.";
    license = lib.licenses.mit;
  };
}
