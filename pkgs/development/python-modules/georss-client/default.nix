{
  lib,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  haversine,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "georss-client";
  version = "0.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-client";
    tag = "v${version}";
    hash = "sha256-KtndXsNvmjSGwqfKqkGAimHbapIC3I0yi4JuDh6cMzs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
