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
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0";
  };

  checkInputs = [ betamax mock pytest ];
  propagatedBuildInputs = [ requests ];

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "A toolbelt of useful classes and functions to be used with python-requests";
    homepage = http://toolbelt.rtfd.org;
    maintainers = with lib.maintainers; [ jgeerds ];
  };
}
