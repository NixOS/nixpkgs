{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyunormalize";
  version = "18.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlodewijck";
    repo = "pyunormalize";
    tag = "v${version}";
    hash = "sha256-CEZUCRszPWXqF1qc9bDukZn+xmV6t7U2jfLWRUpew1c=";
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
