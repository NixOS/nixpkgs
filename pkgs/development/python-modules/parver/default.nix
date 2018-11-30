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
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05dsjmk3ckd175ln8smxr1f6l6qsrjyd8s5vfqc5x7fii3vgyjmc";
  };

  propagatedBuildInputs = [ six attrs arpeggio ];
  checkInputs = [ pytest hypothesis pretend ];

  meta = {
    description = "parver allows parsing and manipulation of PEP 440 version numbers.";
    license = lib.licenses.mit;
  };
}
