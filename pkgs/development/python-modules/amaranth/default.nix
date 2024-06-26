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
  version = "0.4.5";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth";
    rev = "refs/tags/v${version}";
    hash = "sha256-g9dn6gUTdFHz9GMWHERsRLWHoI3E7vjuQDK0usbZO7g=";
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
