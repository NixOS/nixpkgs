{ lib
, buildPythonPackage
, deprecated
, fetchFromGitHub
, importlib-metadata
, ipython
, lark
, matplotlib-inline
, networkx
, numpy
, poetry-core
, pytest-asyncio
, pytest-freezegun
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, qcs-api-client
, qcs-sdk-python
, quil
, respx
, retry
, rpcq
, scipy
, syrupy
, tenacity
, types-deprecated
, types-python-dateutil
, types-retry
}:

buildPythonPackage rec {
  pname = "pyquil";
  version = "4.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-93dHujgGEh9/r9epAiUcUCiFCG7SFTAFoQbjQwwKhN0=";
  };

  pythonRelaxDeps = [
    "lark"
    "networkx"
    "qcs-sdk-python"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    deprecated
    lark
    matplotlib-inline
    networkx
    numpy
    qcs-api-client
    qcs-sdk-python
    quil
    retry
    rpcq
    scipy
    tenacity
    types-deprecated
    types-python-dateutil
    types-retry
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pytest-asyncio
    pytest-freezegun
    pytest-httpx
    pytest-mock
    syrupy
    respx
    ipython
  ];

  disabledTestPaths = [
    # Tests require network access
    "test/e2e/"
    "test/unit/test_api.py"
    "test/unit/test_operator_estimation.py"
    "test/unit/test_wavefunction_simulator.py"
    "test/unit/test_quantum_computer.py"
    "test/unit/test_qvm.py"
    "test/unit/test_reference_wavefunction.py"
    "test/unit/test_reference_density.py"
  ];

  doCheck = false;

  disabledTests = [
    "test_compile_with_quilt_calibrations"
    "test_sets_timeout_on_requests"
    # sensitive to lark parser output
    "test_memory_commands"
    "test_memory"
    "test_classical"
  ];

  pythonImportsCheck = [
    "pyquil"
  ];

  meta = with lib; {
    description = "Python library for creating Quantum Instruction Language (Quil) programs";
    homepage = "https://github.com/rigetti/pyquil";
    changelog = "https://github.com/rigetti/pyquil/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
