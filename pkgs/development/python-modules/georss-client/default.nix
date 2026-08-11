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
  version = "2026.6.1";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-client";
    tag = "v${version}";
    hash = "sha256-3JaFZY6c5wlJs2yE3KJITJIeCgifzurW7chOfQubQ5w=";
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
