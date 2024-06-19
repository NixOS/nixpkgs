{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # propagates
  pyopenssl,
  requests,
  six,

  # tests
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "paypalhttp";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "paypal";
    repo = "paypalhttp_python";
    rev = "refs/tags/${version}";
    hash = "sha256-3ihcpYtpcejPkiyf4g4jveyNU6flQB2sv9EZ5Pd7tUc=";
  };

  postPatch = ''
    substituteInPlace tests/http_response_test.py \
      --replace-fail assertEquals assertEqual
  '';

  propagatedBuildInputs = [
    requests
    six
    pyopenssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  meta = with lib; {
    changelog = "https://github.com/paypal/paypalhttp_python/releases/tag/${version}";
    description = "PayPalHttp is a generic HTTP Client";
    homepage = "https://github.com/paypal/paypalhttp_python";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
