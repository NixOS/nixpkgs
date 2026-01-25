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
  version = "7.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    tag = "v${version}";
    hash = "sha256-3JHmVfGd5X5aEZt8O7Aj/UfYpLtDsI6MPwWxLo7SGBs=";
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
    changelog = "https://github.com/marcospereirampj/python-keycloak/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
