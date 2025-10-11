{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  requests-oauthlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mbzero";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ZlX2dTTXF3Zc5vUymeS+3vXd7+IBnA4tNsvVKNj+ZI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mbzero" ];

  meta = {
    description = "Python bindings for the MusicBrainz and the Cover Art Archive webservices";
    homepage = "https://pypi.org/project/mbzero";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
