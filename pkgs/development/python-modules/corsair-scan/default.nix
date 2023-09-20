{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
, tldextract
, urllib3
, validators
}:

buildPythonPackage rec {
  pname = "corsair-scan";
  version = "0.2.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Santandersecurityresearch";
    repo = "corsair_scan";
    rev = "v${version}";
    sha256 = "09jsv5bag7mjy0rxsxjzmg73rjl7qknzr0d7a7himd7v6a4ikpmk";
  };

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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  pythonImportsCheck = [ "corsair_scan" ];

  meta = with lib; {
    description = "Python module to check for Cross-Origin Resource Sharing (CORS) misconfigurations";
    homepage = "https://github.com/Santandersecurityresearch/corsair_scan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
