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
  version = "0.17";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-DvQifO/jirpacWZccK4WPxnm/iYs1qT5nAYQUDoleO4=";
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
    changelog = "https://github.com/exxamalte/python-georss-client/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
