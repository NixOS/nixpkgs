{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "retry-decorator";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pnpnpn";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0dZq4YbPcH4ItyMnpF7B20YYLtzwniJClBK9gRndU1M=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "retry_decorator"
  ];

  meta = with lib; {
    description = "Decorator for retrying when exceptions occur";
    homepage = "https://github.com/pnpnpn/retry-decorator";
    changelog = "https://github.com/pnpnpn/retry-decorator/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
  };
}
