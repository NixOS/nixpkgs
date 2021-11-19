{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, amqp
, vine
, cached-property
, importlib-metadata
, azure-servicebus
, case
, Pyro4
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "5.2.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f262a2adc71b53e5b7dad4933bbdee65d8766ca4df6a9043b13edaad2144aaec";
  };

  propagatedBuildInputs = [
    amqp
    vine
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
    importlib-metadata
  ];

  checkInputs = [
    azure-servicebus
    case
    Pyro4
    pytestCheckHook
    pytz
  ];

  meta = with lib; {
    description = "Messaging library for Python";
    homepage    = "https://github.com/celery/kombu";
    license     = licenses.bsd3;
  };
}
