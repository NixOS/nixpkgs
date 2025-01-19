{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # propagates
  paypalhttp,

  # tersts
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "paypal-checkout-serversdk";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "paypal";
    repo = "Checkout-Python-SDK";
    tag = version;
    hash = "sha256-04ojNJeqVMdhnGpeCD+wzgKGLI22tVvrMW3gF/SH7KU=";
  };

  postPatch = ''
    # outdated python2 samples
    rm -rf sample
  '';

  propagatedBuildInputs = [ paypalhttp ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # network tests
    "testOrdersPatchTest"
    "testOrdersCreateTest"
    "testOrderGetRequestTest"
  ];

  meta = with lib; {
    changelog = "https://github.com/paypal/Checkout-Python-SDK/releases/tag/${version}";
    description = "Python SDK for Checkout RESTful APIs";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
