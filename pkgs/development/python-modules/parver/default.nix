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
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nylv880zxnm9waw32y8dmdc435jv5gjcajv8qahafm7v1prgcmq";
  };

  propagatedBuildInputs = [ six attrs arpeggio ];
  checkInputs = [ pytest hypothesis pretend ];

  meta = {
    description = "parver allows parsing and manipulation of PEP 440 version numbers.";
    license = lib.licenses.mit;
  };
}
