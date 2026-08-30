{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  setuptools,
  lark,
  numpy,
  sympy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "liberty-parser";
  version = "0.0.29";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "tok";
    repo = "liberty-parser";
    tag = version;
    hash = "sha256-rPEZIRxvmNrDTVD4NG7v2BT3jJXtTisfs4txCG4OfnQ=";
  };

  # Tests try to write to /tmp directly. use $TMPDIR instead.
  postPatch = ''
    substituteInPlace src/liberty/parser.py \
      --replace-fail "/tmp" "$TMPDIR"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    lark
    numpy
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "src/liberty/*.py"
  ];

  pythonImportsCheck = [
    "liberty.parser"
  ];

  meta = {
    description = "Liberty parser for Python";
    homepage = "https://codeberg.org/tok/liberty-parser";
    license = with lib.licenses; [
      asl20
      cc-by-sa-40
      cc0
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
}
