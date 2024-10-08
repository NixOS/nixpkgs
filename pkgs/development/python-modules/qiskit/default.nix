{
  lib,
  pythonOlder,
  pythonAtLeast,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # build-system
  setuptools,
  setuptools-rust,
  rustc,
  cargo,

  # Python Inputs
  rustworkx,
  numpy,
  scipy,
  sympy,
  dill,
  python-dateutil,
  stevedore,
  symengine,

  # Optional inputs
  # Check Inputs
  hypothesis,
  ddt,
  coverage,
  stestr,
  threadpoolctl,
}:

buildPythonPackage rec {
  pname = "qiskit";
  version = "1.1.1";
  pyproject = true;

  # disabled in sync with openstackdocstheme,
  # It that is not disabled anymore, try building for a newer python version
  # Can possibly be excluded somewhere in the dependency tree, but I could not
  # find where
  disabled = pythonOlder "3.6" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    rev = "refs/tags/${version}";
    hash = "sha256-kPYXM37CygY2VpmbE8q9bMXx/m1ni0CiYEUPPCQs2NA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-rust
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-O3mZb2f8NNlpReiLE7lEX83QNTCxdayu+zxBmG0PSXg=";
  };

  # these are taken from requirements-dev.txt test section
  nativeCheckInputs = [
    hypothesis
    ddt
    coverage
    stestr
    threadpoolctl
  ];

  pythonImportsCheck = [ "qiskit" ];
  dependencies = [
    rustworkx
    numpy
    scipy
    sympy
    dill
    python-dateutil
    stevedore
    symengine
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [
      drewrisinger
      pandaman
    ];
  };
}
