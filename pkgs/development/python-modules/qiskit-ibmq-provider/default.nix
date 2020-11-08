{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, arrow
, nest-asyncio
, qiskit-terra
, requests
, requests_ntlm
, websockets
  # Visualization inputs
, ipykernel
, ipyvuetify
, ipywidgets
, matplotlib
, nbconvert
, nbformat
, plotly
, pyperclip
, seaborn
  # check inputs
, pytestCheckHook
, pproxy
, vcrpy
}:

buildPythonPackage rec {
  pname = "qiskit-ibmq-provider";
  version = "0.8.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    sha256 = "0rrpwr4a82j69j5ibl2g0nw8wbpg201cfz6f234k2v6pj500x9nl";
  };

  requiredPythonModules = [
    arrow
    nest-asyncio
    qiskit-terra
    requests
    requests_ntlm
    websockets
    # Visualization/Jupyter inputs
    ipykernel
    ipyvuetify
    ipywidgets
    matplotlib
    nbconvert
    nbformat
    plotly
    pyperclip
    seaborn
  ];

  # websockets seems to be pinned b/c in v8+ it drops py3.5 support. Not an issue here (usually py3.7+, and disabled for older py3.6)
  postPatch = ''
    substituteInPlace requirements.txt --replace "websockets>=7,<8" "websockets"
    substituteInPlace setup.py --replace "websockets>=7,<8" "websockets"
  '';

  # Most tests require credentials to run on IBMQ
  checkInputs = [
    pytestCheckHook
    pproxy
    vcrpy
  ];
  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [ "qiskit.providers.ibmq" ];
  # These disabled tests require internet connection, aren't skipped elsewhere
  disabledTests = [
    "test_old_api_url"
    "test_non_auth_url"
    "test_non_auth_url_with_hub"
  ];

  # Skip tests that rely on internet access (mostly to IBM Quantum Experience cloud).
  # Options defined in qiskit.terra.test.testing_options.py::get_test_options
  QISKIT_TESTS = "skip_online";

  meta = with lib; {
    description = "Qiskit provider for accessing the quantum devices and simulators at IBMQ";
    homepage = "https://github.com/Qiskit/qiskit-ibmq-provider";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
