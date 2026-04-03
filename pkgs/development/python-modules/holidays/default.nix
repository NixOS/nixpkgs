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

buildPythonPackage (finalAttrs: {
  pname = "holidays";
  version = "0.93";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vacanza";
    repo = "python-holidays";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6WgwDkgd6Wn67gNcOw/H2fg55OHcOP7h+76HrML6p80=";
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

    substituteInPlace holidays/version.py \
      --replace-fail 'version("holidays")' '"${finalAttrs.version}"'
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
    changelog = "https://github.com/vacanza/holidays/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      jluttine
    ];
  };
})
