{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "requests-http-signature";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B45P/loXcRKOChSDeHOnlz+67mtmTeAMYlo21TOmV8s=";
  };

  propagatedBuildInputs = [
    cryptography
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/test.py"
  ];

  disabledTests = [
    # Test require network access
    "test_readme_example"
  ];

  pythonImportsCheck = [
    "requests_http_signature"
  ];

  meta = with lib; {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/kislyuk/requests-http-signature";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmai ];
  };
}
