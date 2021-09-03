{ lib
, buildPythonPackage
, fetchFromGitHub
, asgiref
, django
, daphne
, pytest-asyncio
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "channels";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "0jdylcb77n04rqyzg9v6qfzaxp1dnvdvnxddwh3x1qazw3csi5y2";
  };

  propagatedBuildInputs = [
    asgiref
    django
    daphne
  ];

  checkInputs = [
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "channels" ];

  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    license = licenses.bsd3;
    homepage = "https://github.com/django/channels";
    maintainers = with maintainers; [ fab ];
  };
}
