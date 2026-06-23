{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  charset-normalizer,
  chardet,
  banal,
  pyicu,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "normality";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "normality";
    tag = finalAttrs.version;
    hash = "sha256-A3uaGAa3SQSNM73h/OlwvMc5FKbZvdsE6S07C/sEbSc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    charset-normalizer
    chardet
    banal
    pyicu
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "normality" ];

  meta = {
    description = "Micro-library to normalize text strings";
    homepage = "https://github.com/pudo/normality";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
