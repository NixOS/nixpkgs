{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests-toolbelt
, urllib3
, python-jose
, poetry-core
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "2.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    rev = "v${version}";
    sha256 = "sha256-cuj0gJlZDkbJ2HRSMcQvO4nxpjw65CKGEpWCL5sucvg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
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

  doTest = false;  # test fixtures require a running keycloak instance
  pythonImportsCheck = [ "keycloak" ];

  meta = with lib; {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
