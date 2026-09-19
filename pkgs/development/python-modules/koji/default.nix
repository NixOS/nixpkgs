{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchPypi,
  python-dateutil,
  requests,
  requests-gssapi,
  setuptools,
  six,
}:
buildPythonPackage rec {
  pname = "koji";
  version = "1.36.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SBVSueyarVXjk8bF+S6DS8Iojh2gHqZ+5IymNGbEBJ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    python-dateutil
    requests
    requests-gssapi
    six
  ];

  pythonImportsCheck = [ "koji" ];

  meta = {
    description = "Python library for the Koji build system";
    homepage = "https://pagure.io/koji/";
    changelog = "https://pagure.io/koji/blob/koji-${version}/f/docs/source/release_notes/release_notes_${version}.rst";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ caniko ];
  };
}
