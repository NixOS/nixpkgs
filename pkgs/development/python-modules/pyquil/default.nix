{ lib
, buildPythonPackage
, deprecated
, fetchFromGitHub
, importlib-metadata
, ipython
, lark
, networkx
, numpy
, poetry-core
, pytest-asyncio
, pytest-freezegun
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, pythonRelaxDepsHook
, qcs-api-client
, respx
, retry
, rpcq
, scipy
, tenacity
, types-deprecated
, types-python-dateutil
, types-retry
}:

buildPythonPackage rec {
  pname = "pyquil";
  version = "4.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LLhTK/wE42mBTrqjBbnkPvqSG8gP7Vx/3ip66hKHxXc=";
  };

  pythonRelaxDeps = [
    "lark"
    "networkx"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    deprecated
    lark
    networkx
    numpy
    qcs-api-client
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
    respx
    ipython
  ];

  disabledTestPaths = [
    # Tests require network access
    "test/e2e/"
    "test/unit/test_api.py"
    "test/unit/test_engagement_manager.py"
    "test/unit/test_operator_estimation.py"
    "test/unit/test_wavefunction_simulator.py"
    "test/unit/test_compatibility_v2_operator_estimation.py"
    "test/unit/test_compatibility_v2_quantum_computer.py"
    "test/unit/test_compatibility_v2_qvm.py"
    "test/unit/test_quantum_computer.py"
    "test/unit/test_qvm.py"
    "test/unit/test_reference_wavefunction.py"
    # Out-dated
    "test/unit/test_qpu_client.py"
    "test/unit/test_qvm_client.py"
    "test/unit/test_reference_density.py"
  ];

  disabledTests = [
    "test_compile_with_quilt_calibrations"
    "test_sets_timeout_on_requests"
    # sensitive to lark parser output
    "test_memory_commands"
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
