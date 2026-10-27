{
  buildPythonPackage,
  qiskit,
  qiskit-aer,
  stestrCheckHook,
  ddt,
  coverage,
  threadpoolctl,
  hypothesis,
  ipython,
}:

buildPythonPackage {
  pname = "qiskit-tests";
  inherit (qiskit) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    qiskit
    qiskit-aer
    stestrCheckHook
    ddt
    coverage
    threadpoolctl
    hypothesis
    ipython
  ]
  ++ qiskit.optional-dependencies.visualization
  ++ qiskit.optional-dependencies.crosstalk-pass
  ++ qiskit.optional-dependencies.csp-layout-pass;

  preCheck = ''
    mv qiskit qiskit-source
  '';
}
