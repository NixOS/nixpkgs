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
  version = "9.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = pname;
    rev = version;
    sha256 = "sha256-LPD46kxzQ/oTC7XjJn/SXaLQgX613ZoCrJuaRng57Gw=";
  };

  propagatedBuildInputs = [
    marshmallow
    python-dotenv
  ];

  checkInputs = [
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
