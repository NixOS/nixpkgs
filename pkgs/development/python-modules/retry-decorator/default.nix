{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "retry-decorator";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pnpnpn";
    repo = "retry-decorator";
    tag = "v${version}";
    hash = "sha256-0dZq4YbPcH4ItyMnpF7B20YYLtzwniJClBK9gRndU1M=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "retry_decorator" ];

  meta = {
    description = "Decorator for retrying when exceptions occur";
    homepage = "https://github.com/pnpnpn/retry-decorator";
    changelog = "https://github.com/pnpnpn/retry-decorator/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
  };
}
