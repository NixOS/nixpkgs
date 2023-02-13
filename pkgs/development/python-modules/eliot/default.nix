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
  version = "1.14.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2f099a3e8d5ecfc22745766e7cc664a48db64b6b89d986dff270491d8683149";
  };

  nativeCheckInputs = [
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
