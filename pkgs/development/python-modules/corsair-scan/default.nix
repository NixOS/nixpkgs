{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  tldextract,
  urllib3,
  validators,
}:

buildPythonPackage rec {
  pname = "corsair-scan";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Santandersecurityresearch";
    repo = "corsair_scan";
    rev = "refs/tags/v${version}";
    hash = "sha256-s94ZiTL7tBrhUaeB/O3Eh8o8zqtfdt0z8LKep1bZWiY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    validators
    requests
    urllib3
    tldextract
    click
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "corsair_scan" ];

  disabledTests = [
    # Tests want to download Public Suffix List
    "test_corsair_scan_401"
    "test_corsair_scan_origin"
  ];

  meta = with lib; {
    description = "Python module to check for Cross-Origin Resource Sharing (CORS) misconfigurations";
    mainProgram = "corsair";
    homepage = "https://github.com/Santandersecurityresearch/corsair_scan";
    changelog = "https://github.com/Santandersecurityresearch/corsair_scan/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
