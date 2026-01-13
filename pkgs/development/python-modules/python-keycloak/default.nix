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

buildPythonPackage (finalAttrs: {
  pname = "python-keycloak";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZXS29bND4GsJNhTGiUsLo+4FYd8Tubvg/+PJ33tqovY=";
  };

  postPatch = ''
    # Upstream doesn't set version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
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
    changelog = "https://github.com/marcospereirampj/python-keycloak/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
