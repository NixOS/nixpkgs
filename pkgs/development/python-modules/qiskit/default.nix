{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  libiconv,

  dill,
  matplotlib,
  numpy,
  pillow,
  pydot,
  pylatexenc,
  python-constraint,
  rustworkx,
  scipy,
  seaborn,
  setuptools,
  setuptools-rust,
  stevedore,
  symengine,
  sympy,
  typing-extensions,
  z3-solver,
}:

buildPythonPackage rec {
  pname = "qiskit";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    tag = version;
    hash = "sha256-UPkkhXbk66iZdYNaT4W6pBUeyaynrW+M0c3W5X1JI5I=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-R8A9gb3518YU+QcMSR/EN1Uz9B1bqu+9rLNgGqWGjVA=";
  };

  dependencies = [
    dill
    numpy
    rustworkx
    scipy
    stevedore
    typing-extensions
  ];

  optional-dependencies = {
    visualization = [
      matplotlib
      pillow
      pydot
      pylatexenc
      seaborn
      sympy
    ];
    crosstalk-pass = [
      z3-solver
    ];
    csp-layout-pass = [
      python-constraint
    ];
    qpy-compat = [
      symengine
      sympy
    ];
  };

  pythonImportsCheck = [
    "qiskit"
    "qiskit.circuit"
    "qiskit.providers.basic_provider"
  ];

  meta = {
    description = "Software for developing quantum computing programs";
    longDescription = ''
      Open-source SDK for working with quantum computers at the level of
      extended quantum circuits, operators, and primitives.
    '';
    homepage = "https://www.ibm.com/quantum/qiskit";
    downloadPage = "https://github.com/QISKit/qiskit/releases";
    changelog = "https://docs.quantum.ibm.com/api/qiskit/release-notes";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
