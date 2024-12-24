{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  arrow,
  nest-asyncio,
  qiskit-terra,
  requests,
  requests-ntlm,
  websocket-client,
  # Visualization inputs
  withVisualization ? true,
  ipython,
  ipyvuetify,
  ipywidgets,
  matplotlib,
  plotly,
  pyperclip,
  seaborn,
  # check inputs
  pytestCheckHook,
  nbconvert,
  nbformat,
  pproxy,
  qiskit-aer,
  websockets,
  vcrpy,
}:

let
  visualizationPackages = [
    ipython
    ipyvuetify
    ipywidgets
    matplotlib
    plotly
    pyperclip
    seaborn
  ];
in
buildPythonPackage rec {
  pname = "qiskit-ibmq-provider";
  version = "0.20.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7dIspeJpukLDfICoBPPZZWdzkVumtvh+NRxvtmnvWH0=";
  };

  propagatedBuildInputs = [
    arrow
    nest-asyncio
    qiskit-terra
    requests
    requests-ntlm
    websocket-client
    websockets
  ] ++ lib.optionals withVisualization visualizationPackages;

  postPatch = ''
    substituteInPlace setup.py --replace "websocket-client>=1.0.1" "websocket-client"
  '';

  # Most tests require credentials to run on IBMQ
  nativeCheckInputs = [
    pytestCheckHook
    nbconvert
    nbformat
    pproxy
    qiskit-aer
    vcrpy
  ] ++ lib.optionals (!withVisualization) visualizationPackages;

  pythonImportsCheck = [ "qiskit.providers.ibmq" ];
  disabledTests = [
    "test_coder_operators" # fails for some reason on nixos-21.05+
    # These disabled tests require internet connection, aren't skipped elsewhere
    "test_old_api_url"
    "test_non_auth_url"
    "test_non_auth_url_with_hub"
    "test_coder_optimizers" # TODO: reenable when package scikit-quant is packaged, either in NUR or nixpkgs

    # slow tests
    "test_websocket_retry_failure"
    "test_invalid_url"
  ];

  # Skip tests that rely on internet access (mostly to IBM Quantum Experience cloud).
  # Options defined in qiskit.terra.test.testing_options.py::get_test_options
  preCheck = ''
    export QISKIT_TESTS=skip_online
  '';

  meta = with lib; {
    description = "Qiskit provider for accessing the quantum devices and simulators at IBMQ";
    homepage = "https://github.com/Qiskit/qiskit-ibmq-provider";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
