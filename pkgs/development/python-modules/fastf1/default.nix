{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, matplotlib
, numpy
, pandas
, python-dateutil
, requests
, requests-cache
, scipy
, thefuzz
, timple
, websockets
, pytestCheckHook
, pytest-mpl
, pytest-xdist
, requests-mock
, xdoctest
}:

buildPythonPackage rec {
  pname = "fastf1";
  version = "3.0.7";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "theOehrly";
    repo = "Fast-F1";
    rev = "v${version}";
    hash = "sha256-DsGhbCi5H3Z/SX6JBxLzrXP53IUqM2fxZTguWdrjVCA=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    python-dateutil
    requests
    requests-cache
    scipy
    thefuzz
    timple
    websockets
  ];

  pythonImportsCheck = [
  "fastf1"
  "fastf1.ergast"
  "fastf1.livetiming"
  "fastf1.signalr_aio"
  "fastf1.signalr_aio.events"
  "fastf1.signalr_aio.hubs"
  "fastf1.signalr_aio.transports"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    pytest-mpl
    pytest-xdist
    requests-mock
    xdoctest
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
    mkdir test_cache
    # Needed for doctests
    mkdir -p $HOME/${if stdenv.isDarwin then "Library/Caches" else ".cache/fastf1"}/fastf1;
  '';

  disabledTestPaths = [
    # Tests fail due to small differences in font rendering in images
    "fastf1/tests/test_example_plots.py"
  ];

  meta = with lib; {
    description = "Wrapper library for F1 data and telemetry API with additional data processing capabilities";
    homepage = "https://github.com/theOehrly/Fast-F1";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}
