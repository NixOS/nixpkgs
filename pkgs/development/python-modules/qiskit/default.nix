{ lib, pythonOlder, pythonAtLeast, buildPythonPackage, fetchFromGitHub,

# build-system
setuptools, setuptools-rust, rustPlatform, rustc, cargo,

# Python Inputs
rustworkx, numpy, scipy, sympy, dill, python-dateutil, stevedore
, typing-extensions, symengine,
# Optional inputs
withOptionalPackages ? true, qiskit-finance, qiskit-machine-learning
, qiskit-nature, qiskit-optimization, }:
buildPythonPackage rec {
  pname = "qiskit";
  # NOTE: This version denotes a specific set of subpackages. See https://qiskit.org/documentation/release_notes.html#version-history
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    rev = "refs/tags/${version}";
    hash = "sha256-kNjhCxdgXXteVXjFKvItCrlyMGFXKX9HNDtGNTjDvA4=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = "${src}/Cargo.lock"; };

  nativeBuildInputs =
    [ rustPlatform.cargoSetupHook rustc cargo setuptools setuptools-rust ];

  propagatedBuildInputs = [
    numpy
    scipy
    sympy
    dill
    python-dateutil
    stevedore
    typing-extensions
    symengine
    rustworkx
  ];

  doCheck = false;

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger pandaman ];
  };
}
