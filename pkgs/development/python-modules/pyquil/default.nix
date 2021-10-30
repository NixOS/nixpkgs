{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, importlib-metadata
, ipython
, lark-parser
, networkx
, numpy
, poetry-core
, pytest-asyncio
, pytest-freezegun
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonOlder
, qcs-api-client
, retry
, respx
, rpcq
, scipy
}:

buildPythonPackage rec {
  pname = "pyquil";
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OU7/LjcpCxvqlcfdlm5ll4f0DYXf0yxNprM8Muu2wyg=";
  };

  patches = [
    (fetchpatch {
      name = "pyquil-pr-1404-unpin-qcs-api-client-version-pyproject.patch";
      url = "https://github.com/rigetti/pyquil/commit/2e35a4fdf65262fdf39c5091aeddfa3f3564925a.patch";
      sha256 = "sha256-KGDNU2wpzsuifQSbbkoMwaFXspHW6zyIJ5GRZbw+lUY=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lark-parser
    networkx
    numpy
    qcs-api-client
    retry
    rpcq
    scipy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytest-asyncio
    pytest-freezegun
    pytest-httpx
    pytest-mock
    pytestCheckHook
    respx
    ipython
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'lark = "^0.11.1"' 'lark-parser = ">=0.11.1"'
  '';

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
  ];

  disabledTests = [
    "test_compile_with_quilt_calibrations"
    "test_sets_timeout_on_requests"
  ];

  pythonImportsCheck = [ "pyquil" ];

  meta = with lib; {
    description = "Python library for creating Quantum Instruction Language (Quil) programs";
    homepage = "https://github.com/rigetti/pyquil";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
