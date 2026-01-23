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

buildPythonPackage rec {
  pname = "georss-client";
  version = "0.19";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-client";
    tag = "v${version}";
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
    changelog = "https://github.com/exxamalte/python-georss-client/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
