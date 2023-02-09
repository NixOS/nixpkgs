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
, contourpy
, xyzservices
}:

buildPythonPackage rec {
  pname = "bokeh";
  # update together with panel which is not straightforward
  version = "3.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash= "sha256-HChHHvXmEQulvtUTE3/SYFTrxEVLx2hlDq7vxTuJioo=";
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

  nativeCheckInputs = [
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
  ];

  propagatedBuildInputs = [
    contourpy
    pillow
    jinja2
    python-dateutil
    six
    pyyaml
    tornado
    numpy
    pandas
    packaging
    typing-extensions
    xyzservices
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
