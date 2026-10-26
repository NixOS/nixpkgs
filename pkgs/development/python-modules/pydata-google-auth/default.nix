{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-auth-oauthlib,
  google-auth,
  setuptools,
  versioneer,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydata-google-auth";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pydata-google-auth";
    owner = "pydata";
    tag = finalAttrs.version;
    hash = "sha256-NxEpwCkjNWao2bnKOsDgw93N+cVqwM12VfoEu8CyWUU=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    google-auth
    google-auth-oauthlib
  ];

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pydata_google_auth" ];

  meta = {
    description = "Helpers for authenticating to Google APIs";
    homepage = "https://github.com/pydata/pydata-google-auth";
    changelog = "https://github.com/pydata/pydata-google-auth/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
