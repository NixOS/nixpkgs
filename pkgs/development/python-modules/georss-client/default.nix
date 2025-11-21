{
  lib,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  haversine,
  pytestCheckHook,
  requests,
  setuptools,
  xmltodict,
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
    haversine
    xmltodict
    requests
    dateparser
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_client" ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-georss-client";
    changelog = "https://github.com/exxamalte/python-georss-client/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
