{
  lib,
  beancount,
  buildPythonPackage,
  chardet,
  click,
  fetchFromGitHub,
  lxml,
  petl,
  python-magic,
  pytestCheckHook,
  regex,
  setuptools,
}:
buildPythonPackage {
  pname = "beangulp";
  version = "0.2.0-unstable-2025-01-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beangulp";
    rev = "f8d2bc5da40e74461772dcb8e8394fa3c1b2a65d";
    hash = "sha256-uAVsZI+yKdtkS7b9sUIxzzrqouYVwYHopqSIrKF5mmw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beancount
    chardet
    click
    lxml
    python-magic
  ];

  nativeCheckInputs = [
    petl
    pytestCheckHook
    regex
  ];

  pythonImportsCheck = [
    "beangulp"
  ];

  meta = {
    homepage = "https://github.com/beancount/beangulp";
    description = "Importers framework for Beancount";
    longDescription = ''
      Beangulp provides a framework for importing transactions into a Beancoount
      ledger from account statements and other documents and for managing documents.
    '';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ alapshin ];
  };
}
