{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, aiocontextvars
, boltons
, hypothesis
, pyrsistent
, pytestCheckHook
, setuptools
, six
, testtools
, zope_interface
}:

buildPythonPackage rec {
  pname = "eliot";
  version = "1.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wvCZo+jV7PwidFdm58xmSkjbZLa4nZht/ycEkdhoMUk=";
  };

  propagatedBuildInputs = [
    aiocontextvars
    boltons
    pyrsistent
    setuptools
    six
    zope_interface
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    testtools
  ];

  pythonImportsCheck = [
    "eliot"
  ];

  # Tests run eliot-prettyprint in out/bin.
  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    "test_parse_stream"
    # AttributeError: module 'inspect' has no attribute 'getargspec'
    "test_default"
  ];

  meta = with lib; {
    homepage = "https://eliot.readthedocs.io";
    description = "Logging library that tells you why it happened";
    license = licenses.asl20;
    maintainers = with maintainers; [ dpausp ];
  };
}
