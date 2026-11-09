{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  setuptools,

  # runtime dependencies
  qiskit,
  qiskit-algorithms,
  scipy,
  numpy,
  h5py,
  rustworkx,
  sympy,
  withPyscf ? false,
  pyscf,

  # test dependencies
  pytestCheckHook,
  ddt,
  pylatexenc,
  qiskit-aer,
}:

buildPythonPackage (finalAttrs: {
  pname = "qiskit-nature";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-nature";
    tag = finalAttrs.version;
    hash = "sha256-ONSeZx83y2FCikPKxcITdGvSrJf5XhmcrrcejZPJ9u0=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    qiskit
    qiskit-algorithms
    scipy
    numpy
    h5py
    rustworkx
    sympy
  ]
  ++ lib.optional withPyscf pyscf;

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    pylatexenc
    qiskit-aer
  ];

  pythonImportsCheck = [ "qiskit_nature" ];

  meta = {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit-nature/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # drivers/gaussiand/gauopen/*.so
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ chemonke ];
  };
})
