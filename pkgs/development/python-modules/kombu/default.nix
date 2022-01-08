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
  version = "5.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f5d0763fb916808f617b886697b2be28e6bc35026f08e679697fc814b48a608";
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
