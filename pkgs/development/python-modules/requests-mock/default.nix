{ buildPythonPackage, fetchPypi, python
, mock, testrepository, testtools
, requests, six }:

buildPythonPackage rec {
  pname = "requests-mock";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a5fa99db5e3a2a961b6f20ed40ee6baeff73503cf0a553cc4d679409e6170fb";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

  checkInputs = [ mock testrepository testtools ];

  propagatedBuildInputs = [ requests six ];
}
