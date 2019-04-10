{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, flask
, pyquery
, pytest
, pytestrunner
, cairosvg
, tinycss
, cssselect
, lxml
}:

buildPythonPackage rec {
  pname = "pygal";
  version = "2.4.0";

  doCheck = !isPyPy;  # one check fails with pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "9204f05380b02a8a32f9bf99d310b51aa2a932cba5b369f7a4dc3705f0a4ce83";
  };

  buildInputs = [
    flask
    pyquery

    # Should be a check input, but upstream lists it under "setup_requires".
    # https://github.com/Kozea/pygal/issues/430
    pytestrunner
  ];

  checkInputs = [
    pytest
  ];

  preCheck = ''
    # necessary on darwin to pass the testsuite
    export LANG=en_US.UTF-8
  '';

  propagatedBuildInputs = [ cairosvg tinycss cssselect ]
    ++ stdenv.lib.optionals (!isPyPy) [ lxml ];

  meta = with stdenv.lib; {
    description = "Sexy and simple python charting";
    homepage = http://www.pygal.org;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sjourdois ];
  };

}
