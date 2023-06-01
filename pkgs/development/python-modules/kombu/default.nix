{ lib
, amqp
, azure-servicebus
, buildPythonPackage
, cached-property
, case
, fetchPypi
, importlib-metadata
, pyro4
, pytestCheckHook
, pythonOlder
, pytz
, vine
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "5.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N87j7nJflOqLsXPqq3wXYCA+pTu+uuImMoYA+dJ5lhA=";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace "pytz>dev" "pytz"
  '';

  propagatedBuildInputs = [
    amqp
    vine
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
    importlib-metadata
  ];

  nativeCheckInputs = [
    azure-servicebus
    case
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
