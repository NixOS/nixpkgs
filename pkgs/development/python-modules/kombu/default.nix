{ lib
, amqp
, azure-identity
, azure-servicebus
, backports-zoneinfo
, buildPythonPackage
, cached-property
, case
, fetchPypi
, hypothesis
, importlib-metadata
, pyro4
, pytestCheckHook
, pythonOlder
, pytz
, vine
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0ITsH5b3p8N7qegWgjvbwI8Px92zpb5VWAXmkhAil9g=";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytz>dev" "pytz"
  '';

  propagatedBuildInputs = [
    amqp
    vine
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
    importlib-metadata
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
    description = "Messaging library for Python";
    homepage = "https://github.com/celery/kombu";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
