{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b6b9893337bfd9166bee6a62c2b0c9fe7735dcf85948b387ec8cba30e85d8e8";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  meta = {
    homepage = https://more-itertools.readthedocs.org;
    description = "Expansion of the itertools module";
    license = lib.licenses.mit;
  };
}