{
  lib,
  buildPythonPackage,
  chameleon,
  fetchFromGitHub,
  importlib-metadata,
  lingva,
  numpy,
  polib,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  setuptools,
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.85";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vacanza";
    repo = "python-holidays";
    tag = "v${version}";
    hash = "sha256-ExleK66foB2Q/KK7zcPJ16q4ucz3gOkntB2SQETfHqk=";
  };

  build-system = [
    setuptools

    # l10n
    lingva
    chameleon
    polib
  ];

  postPatch = ''
    patchShebangs scripts/l10n/*.py
  '';

  preBuild = ''
    # make l10n
    ./scripts/l10n/generate_po_files.py
    ./scripts/l10n/generate_mo_files.py
  '';

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [
    importlib-metadata
    numpy
    polib
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "holidays" ];

  meta = {
    description = "Generate and work with holidays in Python";
    homepage = "https://github.com/vacanza/python-holidays";
    changelog = "https://github.com/vacanza/holidays/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      jluttine
    ];
  };
}
