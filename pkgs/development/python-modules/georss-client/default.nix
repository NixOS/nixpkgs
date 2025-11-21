{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dateparser,
  haversine,
  requests,
  xmltodict,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "georss-client";
  version = "0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-client";
    tag = "v${version}";
    hash = "sha256-KtndXsNvmjSGwqfKqkGAimHbapIC3I0yi4JuDh6cMzs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dateparser
    haversine
    requests
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_client" ];

  meta = {
    broken = lib.versionAtLeast xmltodict.version "1";
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-georss-client";
    changelog = "https://github.com/exxamalte/python-georss-client/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
