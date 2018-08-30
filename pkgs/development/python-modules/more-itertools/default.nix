{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c476b5d3a34e12d40130bc2f935028b5f636df8f372dc2c1c01dc19681b2039e";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  meta = {
    homepage = https://more-itertools.readthedocs.org;
    description = "Expansion of the itertools module";
    license = lib.licenses.mit;
  };
}