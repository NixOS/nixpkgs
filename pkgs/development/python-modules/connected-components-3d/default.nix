{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  numpy,
  pbr,
  fastremap,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "connected-components-3d";
  version = "3.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seung-lab";
    repo = "connected-components-3d";
    tag = version;
    hash = "sha256-txgQY9k96hFKLrKVLE6ldPdNbSnKOk2FIMrHkRQXlPk=";
  };

  build-system = [
    cython
    numpy
    pbr
    setuptools
  ];

  dependencies = [ numpy ];

  optional-dependencies = {
    stack = [
      # crackle-codec # not in nixpkgs
      fastremap
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ]
  ++ optional-dependencies.stack;

  disabledTests = [
    # requires optional dependency crackle-codec (not in nixpkgs)
    "test_connected_components_stack"
  ];

  pythonImportsCheck = [ "cc3d" ];

  meta = {
    description = "Connected components on discrete and continuous multilabel 3D & 2D images";
    homepage = "https://github.com/seung-lab/connected-components-3d";
    changelog = "https://github.com/seung-lab/connected-components-3d/releases/tag/${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
