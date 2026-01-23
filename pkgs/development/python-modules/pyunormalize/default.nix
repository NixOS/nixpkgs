{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyunormalize";
  version = "17.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlodewijck";
    repo = "pyunormalize";
    tag = "v${version}";
    hash = "sha256-JDcMWaA6r8YRZYJseyKUyPAInrqHHYhQXYmw9rr3ls4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyunormalize" ];

  meta = {
    description = "Unicode normalization forms (NFC, NFKC, NFD, NFKD) independent of the Python core Unicode database";
    homepage = "https://github.com/mlodewijck/pyunormalize";
    changelog = "https://github.com/mlodewijck/pyunormalize/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
