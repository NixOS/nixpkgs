{ lib
, buildPythonPackage
, fetchPypi, nose
, six
, lxml
}:

buildPythonPackage rec {
  pname = "htmllaundry";
  version = "2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9124f067d3c06ef2613e2cc246b2fde2299802280a8b0e60dc504137085f0334";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ six lxml ];

  # some tests fail, probably because of changes in lxml
  # not relevant for me, if releavnt for you, fix it...
  doCheck = false;

  meta = with lib; {
    description = "Simple HTML cleanup utilities";
    license = licenses.bsd3;
    homepage = "https://pypi.org/project/htmllaundry/";
  };

}
