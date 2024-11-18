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
  numpy,
  python-dateutil,
  rustworkx,
  scipy,
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
  pythonOlder,
  pythonAtLeast,
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
  # NOTE: This version denotes a specific set of subpackages. See https://qiskit.org/documentation/release_notes.html#version-history
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    tag = version;
    hash = "sha256-Dqd8ywnACfvrfY7Fzw5zYwhlsDvHZErPGvxBPs2pS04=";
  };
  build-system = [ setuptools-rust ];

  dependencies = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src pname version;
    hash = "sha256-xjZQRvq9HTDpAJ0Uxmjct0GZZMrhka5FfrQclYQAtvM=";
  };

  propagatedBuildInputs =
    [
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
    maintainers = with lib.maintainers; [
      drewrisinger
      pandaman
      guelakais
    ];
  };
}
