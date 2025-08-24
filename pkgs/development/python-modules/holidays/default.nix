{
  lib,
  buildPythonPackage,
  chameleon,
  fetchFromGitHub,
  importlib-metadata,
  lingva,
  polib,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.79";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vacanza";
    repo = "python-holidays";
    tag = "v${version}";
    hash = "sha256-z1baUtD+GFPSRi8siT5X5QSSU2enC0cfnzNwYLHcWTQ=";
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

  doCheck = false;

  nativeCheckInputs = [
    importlib-metadata
    polib
    pytestCheckHook
  ];

  pythonImportsCheck = [ "holidays" ];

  meta = with lib; {
    description = "Generate and work with holidays in Python";
    homepage = "https://github.com/vacanza/python-holidays";
    changelog = "https://github.com/vacanza/python-holidays/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      jluttine
    ];
  };
}
