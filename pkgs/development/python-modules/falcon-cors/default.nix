{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  falcon,
}:

buildPythonPackage rec {
  pname = "falcon-cors";
  version = "1.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lwcolton";
    repo = "falcon-cors";
    tag = version;
    hash = "sha256-jlEWP7gXbWfdY4coEIM6NWuBf4LOGbUAFMNvqip/FcA=";
  };

  build-system = [ setuptools ];

  dependencies = [ falcon ];

  # Test fail with falcon >= 4
  # https://github.com/lwcolton/falcon-cors/issues/25
  doCheck = false;

  pythonImportsCheck = [ "falcon_cors" ];

  meta = {
    description = "CORS support for Falcon";
    homepage = "https://github.com/lwcolton/falcon-cors";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
