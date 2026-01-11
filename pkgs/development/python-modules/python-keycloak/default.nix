{
  lib,
  buildPythonPackage,
  deprecation,
  fetchFromGitHub,
  jwcrypto,
  poetry-core,
  requests,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "4.0.0";
  pyproject = true;

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

  meta = {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    changelog = "https://github.com/marcospereirampj/python-keycloak/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
