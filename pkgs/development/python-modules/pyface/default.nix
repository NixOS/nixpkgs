{ lib
, buildPythonPackage
, fetchPypi
, pygments
, traits
, nose
}:

buildPythonPackage rec {
  pname = "pyface";
  name = "pyface-${version}";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5951f51887e776d5b0ae0ce240c12ad350fe76af63ee96b7a07dda688ba68c4";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ pygments traits ];

  # Lot of NotImplementedError
  doCheck = false;
  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "Traits-capable windowing framework";
    homepage = https://docs.enthought.com/pyface;
    license = lib.licenses.bsd3;
  };
}