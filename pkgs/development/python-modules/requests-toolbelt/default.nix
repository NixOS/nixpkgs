{ lib
, buildPythonPackage
, fetchPypi
, requests
, betamax
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "requests-toolbelt";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6a531936c6fa4c6cfce1b9c10d5c4f498d16528d2a54a22ca00011205a187b5";
  };

  checkInputs = [ betamax mock pytest ];
  propagatedBuildInputs = [ requests ];

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "A toolbelt of useful classes and functions to be used with python-requests";
    homepage = http://toolbelt.rtfd.org;
    maintainers = with lib.maintainers; [ matthiasbeyer jgeerds ];
  };
}