{ buildPythonPackage
, fetchPypi
, futures
, isPy27
, isPyPy
, jinja2
, lib
, mock
, numpy
, nodejs
, packaging
, pillow
#, pytestCheckHook#
, pytest
, python
, python-dateutil
, pyyaml
, selenium
, six
, substituteAll
, tornado
, typing-extensions
, pytz
, flaky
, networkx
, beautifulsoup4
, requests
, nbconvert
, icalendar
, pandas
}:

buildPythonPackage rec {
  pname = "bokeh";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07b26adfbe9fad4bb53e770d220c4d5d0fff8ef6813aa18222fa348bbdb8994b";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-nodejs-npmjs-paths.patch;
      node_bin = "${nodejs}/bin/node";
      npm_bin = "${nodejs}/bin/npm";
    })
  ];

  disabled = isPyPy || isPy27;

  disabledTests = [
    "test_filters" # because of additional warnings
    "test_ext_commands" # AssertionError. Related to tmp?
    "test__version_missing" # fixture 'ipython' not found
  ];

  PYTEST_ADDOPTS = let
    ignoredMarkers = [
      "sampledata"
      "selenium"
    ];
    ignoredTests = disabledTests;
    ignoredPaths = [
      "tests/unit/bokeh/test_client_server.py" # fixture 'ManagedServerLoop' not found
      "tests/unit/bokeh/application/handlers/test_notebook__handlers.py" # fixture 'ipython' not found
    ];
  in lib.concatStringsSep " " ([
    "-m '${lib.concatMapStringsSep " and " (s: "not " + s)  ignoredMarkers}'"
    "-k '${lib.concatMapStringsSep " and " (s: "not " + s)  ignoredTests}'"
    "-x"
  ] ++ map (path: "--ignore=${path}") ignoredPaths);

  checkInputs = [
    mock
    pytest
    pillow
    selenium
    pytz
    flaky
    networkx
    beautifulsoup4
    requests
    nbconvert
    icalendar
    pandas
  ];

  propagatedBuildInputs = [
    pillow
    jinja2
    python-dateutil
    six
    pyyaml
    tornado
    numpy
    packaging
    typing-extensions
  ]
  ++ lib.optionals ( isPy27 ) [
    futures
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = {
    description = "Statistical and novel interactive HTML plots for Python";
    homepage = "https://github.com/bokeh/bokeh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
