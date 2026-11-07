{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  callPackage,

  # build
  setuptools,
  setuptools-rust,
  cargo,
  rustPlatform,
  rustc,
  libiconv, # Darwin

  # runtime dependencies
  numpy,
  scipy,
  rustworkx,
  dill,
  stevedore,
  typing-extensions,

  # optional dependencies
  matplotlib,
  pydot,
  pillow,
  pylatexenc,
  seaborn,
  sympy,
  z3-solver,
  python-constraint2,
  symengine,
}:

buildPythonPackage (finalAttrs: {
  pname = "qiskit";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    tag = finalAttrs.version;
    hash = "sha256-/JB93EA7WI6il6sFeo9FtqjhEDci++EAN8k7Lm1+zEE=";
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
    inherit (finalAttrs) src pname version;
    hash = "sha256-ehZO+ABAUIrp2lE8+UC4BJOh1wJ5dhxnup0TfPI7V7A=";
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
      pydot
      pillow
      pylatexenc
      seaborn
      sympy
    ];
    crosstalk-pass = [
      z3-solver
    ];
    csp-layout-pass = [
      python-constraint2
    ];
    qpy-compat = [
      symengine
      sympy
    ];
  };

  doCheck = false;

  # qiskit tests depend on qiskit-aer; infinie recursion
  passthru.tests.withAer = callPackage ./tests.nix {
    qiskit = finalAttrs.finalPackage;
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
    maintainers = with lib.maintainers; [ chemonke ];
  };
})
