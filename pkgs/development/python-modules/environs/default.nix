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
  version = "9.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = pname;
    rev = version;
    sha256 = "0n0l9jici2d1pck5pf1c96jj3lhw91jki9nsgxzpikvpyvsw7wga";
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
