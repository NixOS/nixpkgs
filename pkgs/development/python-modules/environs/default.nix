{ lib
, buildPythonPackage
, dj-database-url
, dj-email-url
, django-cache-url
, fetchFromGitHub
, marshmallow
, pytestCheckHook
, python-dotenv
, pythonOlder
}:

buildPythonPackage rec {
  pname = "environs";
  version = "9.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = pname;
    rev = version;
    hash = "sha256-hucApIn7ul7+MC2W811VTxZNO8Pqb6HDXz9VRcEdmIc=";
  };

  propagatedBuildInputs = [
    marshmallow
    python-dotenv
  ];

  nativeCheckInputs = [
    dj-database-url
    dj-email-url
    django-cache-url
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "environs"
  ];

  meta = with lib; {
    description = "Python modle for environment variable parsing";
    homepage = "https://github.com/sloria/environs";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
