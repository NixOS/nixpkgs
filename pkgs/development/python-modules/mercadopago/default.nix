{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "mercadopago";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mercadopago";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-ABxYGYUBOzeOSE0yK8jym+ldinDUCTpqO165OWhszgs=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # require internet
  doCheck = false;

  pythonImportsCheck = [
    "mercadopago"
  ];

  meta = with lib; {
    description = "This library provides developers with a simple set of bindings to help you integrate Mercado Pago API to a website and start receiving payments.";
    homepage = "https://www.mercadopago.com";
    changelog = "https://github.com/mercadopago/sdk-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
