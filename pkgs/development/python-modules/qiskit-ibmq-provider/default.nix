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
  version = "0.6.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    sha256 = "0arbhwaa2kx04jbrj6hk3vvn92wdk6lrr9zx36pr6p22r0yyxnj9";
  };

  propagatedBuildInputs = [
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
  prePatch = ''
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
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
