{ stdenv
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
  version = "1.12.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wabv7hk63l12881f4zw02mmj06583qsx2im0yywdjlj8f56vqdn";
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

  meta = with stdenv.lib; {
    homepage = "https://eliot.readthedocs.io";
    description = "Logging library that tells you why it happened";
    license = licenses.asl20;
    maintainers = [ maintainers.dpausp ];
  };
}
