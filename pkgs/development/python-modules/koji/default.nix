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
  version = "1.36.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j6KnXseGwQB83MLFWJVtxkY7axzI9oIBonsUUVZYZEQ=";
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
