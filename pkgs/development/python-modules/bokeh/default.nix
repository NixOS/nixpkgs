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
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0cf59774d7c74b7173b82ce36bde35b8fe9da0f960364ba3c4df0d1fbd874d6";
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
    homepage = https://github.com/bokeh/bokeh;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
