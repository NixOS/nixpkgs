{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  dawg2-python,
  pymorphy3-dicts-ru,
  pymorphy3-dicts-uk,

  # tests
  pytestCheckHook,
  click,
}:

buildPythonPackage rec {
  pname = "pymorphy3";
  version = "2.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "no-plagiarism";
    repo = "pymorphy3";
    tag = version;
    hash = "sha256-5s5v6+vMCeyn/73G5uUfRtTGkkqa7RNW8/r1v3Ay4us=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dawg2-python
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
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pymorphy3" ];

  meta = {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/no-plagiarism/pymorphy3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
