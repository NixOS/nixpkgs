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
  version = "5.1.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01481d99f4606f6939cdc9b637264ed353ee9e3e4f62cfb582324142c41a572d";
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
