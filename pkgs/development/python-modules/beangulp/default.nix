{
  lib,
  beancount,
  beautifulsoup4,
  buildPythonPackage,
  chardet,
  click,
  fetchFromGitHub,
  fetchpatch2,
  lxml,
  petl,
  python-magic,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "beangulp";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beangulp";
    tag = "v${version}";
    hash = "sha256-h7xLHwEyS+tOI7v6Erp12VfVnxOf4930++zghhC3in4=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/beancount/beangulp/commit/254bfb38ffed049ef8f3041bfaf01b3f5a8aa771.patch?full_index=1";
      hash = "sha256-ojysT23K0xmFafzTnRZiHkLS2ioDR/tVK02mfF7N9so=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    beancount
    beautifulsoup4
    chardet
    click
    lxml
    python-magic
  ];

  nativeCheckInputs = [
    petl
    pytestCheckHook
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
