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
  version = "0.5.1";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth";
    rev = "refs/tags/v${version}";
    hash = "sha256-76wuxWz6RikFFJH+5kte57GcVhusJKtcMo5M/2U+Cl8=";
  };

  nativeBuildInputs = [
    git
    pdm-backend
  ];

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
