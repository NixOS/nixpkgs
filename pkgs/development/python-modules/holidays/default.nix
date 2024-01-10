{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# l10n
, polib
, lingua
, chameleon

# dependencies
, python-dateutil

# tests
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.39";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dr-prodigy";
    repo = "python-holidays";
    rev = "refs/tags/v${version}";
    hash = "sha256-PsrdR4voEAiEhgoeR03Xp/tacqtcEt1FhO4kfMYkSos=";
  };

  nativeBuildInputs = [
    setuptools

    # l10n
    lingua
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

  propagatedBuildInputs = [
    python-dateutil
  ];

  doCheck = false;

  nativeCheckInputs = [
    importlib-metadata
    polib
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "holidays"
  ];

  disabledTests = [
    # Failure starting with 0.24
    "test_l10n"
  ];

  meta = with lib; {
    description = "Generate and work with holidays in Python";
    homepage = "https://github.com/dr-prodigy/python-holidays";
    changelog = "https://github.com/dr-prodigy/python-holidays/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab jluttine ];
  };
}

