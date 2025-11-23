{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  haversine,
  python-dateutil,
  requests,
  xmltodict,

  # testing
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "georss-client";
  version = "0.19-unstable-20251121";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-client";
    rev = "8ff46176ab45a02a3a29c1de3871a186243df3a7";
    hash = "sha256-+CmauNb+5mDbZXQCd8ZxZCz6FSfEPAnktkMjvQueiO0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    haversine
    python-dateutil
    requests
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_client" ];

  meta = {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-georss-client";
    # Reinstate when back on a stable release
    # changelog = "https://github.com/exxamalte/python-georss-client/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
