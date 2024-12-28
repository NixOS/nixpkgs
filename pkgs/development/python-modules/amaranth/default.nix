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
  format = "pyproject";
  version = "0.5.4";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth";
    tag = "v${version}";
    hash = "sha256-e4htbNq6OCy8ZTS1UnucbU987reukP4J1CbWhT39K6E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "pdm-backend~=2.3.0" \
        "pdm-backend>=2.3.0"
  '';

  nativeBuildInputs = [ git ];
  build-system = [ pdm-backend ];

  dependencies =
    [
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
