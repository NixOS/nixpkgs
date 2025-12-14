{
  lib,
  buildPythonPackage,
  fetchPypi,

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

  src = fetchPypi {
    inherit version;
    pname = "paypal-checkout-serversdk";
    hash = "sha256-gPYrotn+IrWMLOHzEBRqz2A3CISTOY26ixu2e0k67l4=";
  };

  postPatch = ''
    # outdated python2 samples
    rm -rf sample
  '';

  propagatedBuildInputs = [ paypalhttp ];

  # test_harness.py is missing
  doInstallCheck = false;

  meta = {
    changelog = "https://github.com/paypal/Checkout-Python-SDK/releases/tag/${version}";
    description = "Python SDK for Checkout RESTful APIs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
