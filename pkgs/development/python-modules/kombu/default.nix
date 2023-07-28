{ lib
, amqp
, azure-identity
, azure-servicebus
, backports-zoneinfo
, buildPythonPackage
, case
, fetchPypi
, hypothesis
, pyro4
, pytestCheckHook
, pythonOlder
, pytz
, vine
, typing-extensions
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "5.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+9dXLZLAv3HBEqa0UWMVPepae2pwHsFrVown0P0jcPI=";
  };

  propagatedBuildInputs = [
    amqp
    vine
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    azure-identity
    azure-servicebus
    case
    hypothesis
    pyro4
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [
    "kombu"
  ];

  meta = with lib; {
    changelog = "https://github.com/celery/kombu/releases/tag/v${version}";
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
