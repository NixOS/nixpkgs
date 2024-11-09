{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  ifaddr,
  lxml,
  poetry-core,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pywemo";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pywemo";
    repo = "pywemo";
    rev = "refs/tags/${version}";
    hash = "sha256-XpCRrCJYHv1so5/aHoGrtkgp3RX1NUKPUawJqK/FaG0=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    ifaddr
    lxml
    requests
    urllib3
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    hypothesis
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pywemo" ];

  meta = with lib; {
    description = "Python module to discover and control WeMo devices";
    homepage = "https://github.com/pywemo/pywemo";
    changelog = "https://github.com/pywemo/pywemo/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
