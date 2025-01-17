{
  stdenv,
  lib,
  pythonAtLeast,
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
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    rev = "refs/tags/${version}";
    hash = "sha256-kNjhCxdgXXteVXjFKvItCrlyMGFXKX9HNDtGNTjDvA4=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    setuptools-rust
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src pname version;
    hash = "sha256-GVGSeNt11jw1jtBPcWq3YgjRpFnvDH/SN8CaLb5iM9Y=";
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
    "qiskit.pulse"
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
    ];
  };
}
