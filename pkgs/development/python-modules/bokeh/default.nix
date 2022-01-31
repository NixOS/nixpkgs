{ buildPythonPackage
, fetchPypi
, futures ? null
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
, pythonImportsCheckHook
}:

buildPythonPackage rec {
  pname = "bokeh";
  # update together with panel which is not straightforward
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0a4b53364ed3b7eb936c5cb1a4f4132369e394c7ae0a8ef420459410958033d";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-nodejs-npmjs-paths.patch;
      node_bin = "${nodejs}/bin/node";
      npm_bin = "${nodejs}/bin/npm";
    })
  ];

  disabled = isPyPy || isPy27;

  nativeBuildInputs = [
    pythonImportsCheckHook
  ];

  pythonImportsCheck = [
    "bokeh"
  ];

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

  # This test suite is a complete pain. Somehow it can't find its fixtures.
  doCheck = false;

  meta = {
    description = "Statistical and novel interactive HTML plots for Python";
    homepage = "https://github.com/bokeh/bokeh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
