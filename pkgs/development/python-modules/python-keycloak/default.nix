{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, python-jose
, pythonOlder
, requests
, requests-toolbelt
, urllib3
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "2.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    rev = "v${version}";
    hash = "sha256-cuj0gJlZDkbJ2HRSMcQvO4nxpjw65CKGEpWCL5sucvg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace 'requests-toolbelt = "^0.9.1"' 'requests-toolbelt = "*"'
  '';

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    python-jose
    urllib3
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
    maintainers = with maintainers; [ costrouc ];
  };
}
