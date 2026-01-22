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
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    tag = version;
    hash = "sha256-YGsBpNyM28fDG+mXs3hIA6K2kuE1getB8tTMLdHMa5k=";
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
    hash = "sha256-Mpy5KkqSjlTtezZ2BQnai+PBG+8qLPmYj1AocdIhhvI=";
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
