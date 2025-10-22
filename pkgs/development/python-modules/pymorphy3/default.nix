{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  dawg-python,
  docopt,
  pymorphy3-dicts-ru,
  pymorphy3-dicts-uk,

  # tests
  pytestCheckHook,
  click,
}:

buildPythonPackage rec {
  pname = "pymorphy3";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "no-plagiarism";
    repo = "pymorphy3";
    tag = version;
    hash = "sha256-Ula2OQ80dcGeMlXauehXnlEkHLjjm4jZn39eFNltbEA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dawg-python
    docopt
    pymorphy3-dicts-ru
    pymorphy3-dicts-uk
  ];

  optional-dependencies = {
    CLI = [
      click
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "pymorphy3" ];

  meta = {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/no-plagiarism/pymorphy3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
