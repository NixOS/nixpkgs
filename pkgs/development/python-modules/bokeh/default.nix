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
  version = "0.12.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2891b883b30107dc610a7e963a21222f1fd096844d157c09db115179cfab6513";
  };

  disabled = isPyPy;

  # Some test that uses tornado fails
#   doCheck = false;

  checkInputs = [ mock pytest pillow selenium ];

  propagatedBuildInputs = [
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
    homepage = "http://github.com/bokeh/bokeh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
