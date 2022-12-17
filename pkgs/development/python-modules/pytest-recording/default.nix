{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-recording";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cd3289745ab3156d43eb9c8e7f7d00a926f3ae5c9cf425bec649b2fe15bad5b";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A pytest plugin that allows you recording of network interactions via VCR.py";
    homepage = "https://github.com/kiwicom/pytest-recording";
    license = licenses.mit;
    maintainers = with maintainers; [ dennajort ];
  };
}
