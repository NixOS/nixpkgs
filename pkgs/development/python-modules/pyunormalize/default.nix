{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyunormalize";
  version = "16.0.0";

  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mlodewijck";
    repo = pname;
    rev = "4b45c576567fb0293acb93a308c97cbaba3caa5f";
    hash = "sha256-tcV6kusmvBV7CkHGJNjAJvkAeP1VmgLSQGejv2j4290=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyunormalize" ];

  meta = with lib; {
    description = "Unicode normalization forms (NFC, NFKC, NFD, NFKD) independent of the Python core Unicode database";
    homepage = "https://github.com/mlodewijck/pyunormalize";
    license = licenses.mit;
    maintainers = [ ];
  };
}
