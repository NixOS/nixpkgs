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
, pytest
, python
, python-dateutil
, pyyaml
, selenium
, six
, substituteAll
, tornado
}:

buildPythonPackage rec {
  pname = "bokeh";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rywd6c6hi0c6yg18j5zxssjd07a5hafcd21xr3q2yvp3aj3h3f6";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-nodejs-npmjs-paths.patch;
      node_bin = "${nodejs}/bin/node";
      npm_bin = "${nodejs}/bin/npm";
    })
  ];

  disabled = isPyPy;

  checkInputs = [
    mock
    pytest
    pillow
    selenium
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
  ]
  ++ lib.optionals ( isPy27 ) [
    futures
  ];

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
