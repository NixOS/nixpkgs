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
, pythonImportsCheckHook
}:

buildPythonPackage rec {
  pname = "bokeh";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dfabf228f55676b88acc464f416e2b13ee06470a8ad1dd3e609bb789425fbad";
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
