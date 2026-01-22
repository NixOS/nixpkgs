{
  lib,
  buildPythonPackage,
  expiringdict,
  fetchPypi,
  google-api-python-client,
  google-auth,
  google-auth-httplib2,
  google-auth-oauthlib,
  oauth2client,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "drivelib";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lTyRncKBMoU+ahuekt+LQ/PhNqySf4a4qLSmyo1t468=";
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
    expiringdict
    google-api-python-client
    google-auth
    google-auth-httplib2
    google-auth-oauthlib
    oauth2client
  ];

  # Tests depend on a google auth token
  doCheck = false;

  pythonImportsCheck = [ "drivelib" ];

  meta = {
    description = "Easy access to the most common Google Drive API calls";
    homepage = "https://github.com/Lykos153/python-drivelib";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ gravndal ];
  };
}
