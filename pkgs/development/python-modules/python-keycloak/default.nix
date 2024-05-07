{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, requests
, requests-toolbelt
, deprecation
, jwcrypto
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    rev = "v${version}";
    hash = "sha256-ZXS29bND4GsJNhTGiUsLo+4FYd8Tubvg/+PJ33tqovY=";
  };

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    deprecation
    jwcrypto
    requests
    requests-toolbelt
  ];

  # Test fixtures require a running keycloak instance
  doCheck = false;

  pythonImportsCheck = [
    "keycloak"
  ];

  meta = with lib; {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
