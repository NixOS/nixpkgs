{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pdm-backend,
  pyvcd,
  jinja2,
  importlib-resources,
  importlib-metadata,
  git,

  # for tests
  pytestCheckHook,
  symbiyosys,
  yices,
  yosys,
}:

buildPythonPackage rec {
  pname = "amaranth";
  format = "pyproject";
  version = "0.5.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth";
    rev = "refs/tags/v${version}";
    hash = "sha256-+EV2NgYSuCbYTQKeBUN+/D0attfrJ3cso7U6RjLEIbg=";
  };

  nativeBuildInputs = [
    git
    pdm-backend
  ];

  dependencies =
    [
      jinja2
      pyvcd
    ]
    ++ lib.optional (pythonOlder "3.9") importlib-resources
    ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
    symbiyosys
    yices
    yosys
  ];

  pythonImportsCheck = [ "amaranth" ];

  meta = with lib; {
    description = "Modern hardware definition language and toolchain based on Python";
    mainProgram = "amaranth-rpc";
    homepage = "https://amaranth-lang.org/docs/amaranth";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      thoughtpolice
      pbsds
    ];
  };
}
