{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build
  setuptools,

  # runtime dependencies
  numpy,
  scipy,
  qiskit,
  # test dependencies
  pytestCheckHook,
  ddt,
  rustworkx,
}:

buildPythonPackage (finalAttrs: {
  pname = "qiskit-algorithms";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qiskit-community";
    repo = "qiskit-algorithms";
    tag = finalAttrs.version;
    hash = "sha256-qQ8UID43tc6ODUyocas12cbXEsVdP7/q4s/fkYrP4fc=";
  };

  patches = [
    # Backport upstream's TrotterQRTE fix for Qiskit >= 2.2, including its regression test.
    # https://github.com/qiskit-community/qiskit-algorithms/pull/252
    (fetchpatch {
      url = "https://github.com/qiskit-community/qiskit-algorithms/commit/6700f3cde8fe7e170e515b544b9b284a50a43af4.patch";
      includes = [
        "qiskit_algorithms/time_evolvers/trotterization/trotter_qrte.py"
        "test/time_evolvers/test_trotter_qrte.py"
      ];
      hash = "sha256-jI67U3Zc+I+XuQ8z+4SQV2Z/jmwW8hb+QqU/amhHEOM=";
    })
    # Backport the optimizer fix from upstream's Python 3.14 support change.
    # https://github.com/qiskit-community/qiskit-algorithms/pull/268
    (fetchpatch {
      url = "https://github.com/qiskit-community/qiskit-algorithms/commit/2ed82f6cde90fda6f750089cf6f0f8086e87aed8.patch";
      includes = [ "qiskit_algorithms/optimizers/p_bfgs.py" ];
      hash = "sha256-94cw80Mb1uC8WJtvmjnE44ysCPxoyhPgGBnSQOQt4dg=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    qiskit
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    rustworkx
  ];

  pythonImportsCheck = [
    "qiskit_algorithms"
  ];

  meta = {
    description = "Library of quantum algorithms for Qiskit";
    homepage = "https://github.com/qiskit-community/qiskit-algorithms";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chemonke ];
  };
})
