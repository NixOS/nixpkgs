{
  stdenv,
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  libiconv,

  dill,
  numpy,
  python-dateutil,
  rustworkx,
  scipy,
  setuptools,
  setuptools-rust,
  stevedore,
  symengine,
  sympy,
  typing-extensions,

  withVisualization ? false,
  matplotlib,
  pillow,
  pydot,
  pylatexenc,
  seaborn,

  withCrosstalkPass ? false,
  z3-solver,

  withCspLayoutPass ? false,
  python-constraint,
}:

let
  visualizationPackages = [
    matplotlib
    pillow
    pydot
    pylatexenc
    seaborn
  ];
  crosstalkPackages = [ z3-solver ];
  cspLayoutPackages = [ python-constraint ];
in

buildPythonPackage rec {
  pname = "qiskit";
  version = "2.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    tag = version;
    hash = "sha256-9/Z9wFAgSjC+3FsfUz9zwqXEU8EBB9UJdXXrf+kvj6o=";
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
    hash = "sha256-xVQmOBn7rGVa2Ze71kRn9j4WnKh0aMTKB965ZfCpqkQ=";
  };

  dependencies = [
    dill
    numpy
    python-dateutil
    rustworkx
    scipy
    stevedore
    symengine
    sympy
    typing-extensions
  ]
  ++ lib.optionals withVisualization visualizationPackages
  ++ lib.optionals withCrosstalkPass crosstalkPackages
  ++ lib.optionals withCspLayoutPass cspLayoutPackages;

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
