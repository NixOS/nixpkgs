{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
, pytest-sugar
}:

buildPythonPackage rec {
  pname = "junit-xml";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08fw86azza6d3l3nx34kq69cpwmmfqpn7xrb8pdlxmhr1941qbv0";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest pytest-sugar ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Creates JUnit XML test result documents that can be read by tools such as Jenkins";
    homepage = https://github.com/kyrus/python-junit-xml;
    maintainers = with maintainers; [ multun ];
    license = licenses.mit;
  };
}
