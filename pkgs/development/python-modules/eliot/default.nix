{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, aiocontextvars
, boltons
, hypothesis
, pyrsistent
, pytest
, setuptools
, six
, testtools
, zope_interface
}:

buildPythonPackage rec {
  pname = "eliot";
  version = "1.13.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5760194b308a7ab35514ae1b942d88e9f2359071556d82580383f09ca586fff7";
  };

  checkInputs = [
    hypothesis
    testtools
    pytest
   ];

  propagatedBuildInputs = [
    aiocontextvars
    boltons
    pyrsistent
    setuptools
    six
    zope_interface
  ];

  pythonImportsCheck = [ "eliot" ];

  # Tests run eliot-prettyprint in out/bin.
  # test_parse_stream is broken, skip it.
  checkPhase = ''
    export PATH=$out/bin:$PATH
    pytest -k 'not test_parse_stream'
  '';

  meta = with lib; {
    homepage = "https://eliot.readthedocs.io";
    description = "Logging library that tells you why it happened";
    license = licenses.asl20;
    maintainers = [ maintainers.dpausp ];
  };
}
