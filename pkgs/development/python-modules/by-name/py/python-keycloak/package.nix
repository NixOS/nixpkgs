{
  lib,
  buildPythonPackage,
  deprecation,
  fetchFromGitHub,
  jwcrypto,
  poetry-core,
  pythonOlder,
  requests,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    tag = "v${version}";
    hash = "sha256-ZXS29bND4GsJNhTGiUsLo+4FYd8Tubvg/+PJ33tqovY=";
  };

  postPatch = ''
    # Upstream doesn't set version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    deprecation
    jwcrypto
    requests
    requests-toolbelt
  ];

  # Test fixtures require a running keycloak instance
  doCheck = false;

  pythonImportsCheck = [ "keycloak" ];

  meta = with lib; {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    changelog = "https://github.com/marcospereirampj/python-keycloak/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
