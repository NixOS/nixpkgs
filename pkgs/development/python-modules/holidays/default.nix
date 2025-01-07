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
  version = "0.64";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vacanza";
    repo = "python-holidays";
    tag = "v${version}";
    hash = "sha256-rPQr7nyouBepTi4tW0+wrbROYyWo92KkZUI6ff5jl7I=";
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
    changelog = "https://github.com/vacanza/python-holidays/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      jluttine
    ];
  };
}
