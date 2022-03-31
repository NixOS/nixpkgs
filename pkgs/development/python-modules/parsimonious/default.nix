{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  version = "0.9.0";
  pname = "parsimonious";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sq0a5jovZb149eCorFEKmPNgekPx2yqNRmNqXZ5KMME=";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  # performance tests tend to fail sometimes
  NOSE_EXCLUDE = "test_benchmarks";

  meta = with lib; {
    homepage = "https://github.com/erikrose/parsimonious";
    description = "Fast arbitrary-lookahead parser written in pure Python";
    license = licenses.mit;
  };

}
