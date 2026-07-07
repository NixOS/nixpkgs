{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  defusedxml,
  python-dateutil,
  requests,
  requests-gssapi,
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

  pythonImportsCheck = [
    "koji"
    "koji_cli"
  ];

  meta = {
    description = "System for building and tracking RPMs";
    homepage = "https://pagure.io/koji/";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "koji";
  };
}
