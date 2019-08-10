{ buildPythonPackage
, fetchPypi
, futures
, isPy3k
, isPyPy
, jinja2
, lib
, mock
, numpy
, pillow
, pytest
, python
, python-dateutil
, pyyaml
, selenium
, six
, tornado
}:

buildPythonPackage rec {
  pname = "bokeh";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m27j29jpi977y95k272xc24qkl5bkniy046cil116hrbgnppng2";
  };

  disabled = isPyPy;

  checkInputs = [ mock pytest pillow selenium ];

  propagatedBuildInputs = [
    pillow
    jinja2
    python-dateutil
    six
    pyyaml
    tornado
    numpy
  ]
  ++ lib.optionals ( !isPy3k ) [ futures ];

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
