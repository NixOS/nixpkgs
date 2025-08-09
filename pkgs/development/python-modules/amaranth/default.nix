{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pdm-backend,
  jschon,
  pyvcd,
  jinja2,
  importlib-resources,
  importlib-metadata,
  git,

  # for tests
  pytestCheckHook,
  sby,
  yices,
  yosys,
}:

buildPythonPackage rec {
  pname = "amaranth";
  version = "0.5.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth";
    tag = "v${version}";
    hash = "sha256-E/PJrvBmlS39KgzDz9sArq4BXwk/JmIMtdxL7MdrWlc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pdm-backend~=2.3.0" "pdm-backend>=2.3.0"
  '';

  nativeBuildInputs = [ git ];

  build-system = [ pdm-backend ];

  dependencies = [
    jschon
    jinja2
    pyvcd
  ]
  ++ lib.optional (pythonOlder "3.9") importlib-resources
  ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
    sby
    yices
    yosys
  ];

  pythonImportsCheck = [ "amaranth" ];

  disabledTests = [
    "verilog"
    "test_reversible"
    "test_distance"
  ];

  disabledTestPaths = [
    # Subprocesses
    "tests/test_examples.py"
    # Verification failures
    "tests/test_lib_fifo.py"
  ];

  meta = with lib; {
    description = "Modern hardware definition language and toolchain based on Python";
    homepage = "https://amaranth-lang.org/docs/amaranth";
    changelog = "https://github.com/amaranth-lang/amaranth/blob/${src.tag}/docs/changes.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      thoughtpolice
      pbsds
    ];
    mainProgram = "amaranth-rpc";
  };
}
