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

  # .pem files for tests aren't present on PyPI
  src = fetchFromGitHub {
    owner = "pyauth";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jsplqrxadjsc86f0kb6dgpblgwplxrpi0ql1a714w8pbbz4z3h7";
  };

  propagatedBuildInputs = [
    cryptography
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test/test.py" ];

  disabledTests = [
    # Test require network access
    "test_readme_example"
  ];

  pythonImportsCheck = [ "requests_http_signature" ];

  meta = with lib; {
    description = "A Requests auth module for HTTP Signature";
    homepage = "https://github.com/kislyuk/requests-http-signature";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmai ];
  };
}
