{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, mock
, pytest
, flask
, jinja2
, markupsafe
, werkzeug
, itsdangerous
, dateutil
, requests
, six
, pygments
, pystache
, markdown
, pyyaml
, pyzmq
, tornado
, colorama
, isPy3k
, futures
, websocket_client
, numpy
, pandas
, greenlet
, python
, bkcharts
, pillow
, selenium
}:

buildPythonPackage rec {
  pname = "bokeh";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43aa8b867f2db99c0cf3178149d2533e9e954a8355d6161381d0b8765c90db5e";
  };

  disabled = isPyPy;

  # Some test that uses tornado fails
#   doCheck = false;

  checkInputs = [ mock pytest pillow selenium ];

  propagatedBuildInputs = [
    pillow
    flask
    jinja2
    markupsafe
    werkzeug
    itsdangerous
    dateutil
    requests
    six
    pygments
    pystache
    markdown
    pyyaml
    pyzmq
    tornado
    colorama
    bkcharts
  ]
  ++ lib.optionals ( !isPy3k ) [ futures ]
  ++ lib.optionals ( !isPy3k && !isPyPy ) [ websocket_client ]
  ++ lib.optionals ( !isPyPy ) [ numpy pandas greenlet ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s bokeh/tests
  '';

  meta = {
    description = "Statistical and novel interactive HTML plots for Python";
    homepage = https://github.com/bokeh/bokeh;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
