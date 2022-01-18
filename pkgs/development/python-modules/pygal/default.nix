{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPyPy
, flask
, pyquery
, pytest
, pytest-runner
, cairosvg
, tinycss
, cssselect
, lxml
}:

buildPythonPackage rec {
  pname = "pygal";
  version = "3.0.0";

  doCheck = !isPyPy; # one check fails with pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KSP5XS5RWTCqWplyGdzO+/PZK36vX8HJ/ruVsJk1/bI=";
  };

  buildInputs = [
    flask
    pyquery

    # Should be a check input, but upstream lists it under "setup_requires".
    # https://github.com/Kozea/pygal/issues/430
    pytest-runner
  ];

  checkInputs = [
    pytest
  ];

  preCheck = ''
    # necessary on darwin to pass the testsuite
    export LANG=en_US.UTF-8
  '';

  postPatch = ''
    substituteInPlace setup.cfg --replace "[pytest]" "[tool:pytest]"
  '';

  propagatedBuildInputs = [ cairosvg tinycss cssselect ]
    ++ lib.optionals (!isPyPy) [ lxml ];

  meta = with lib; {
    description = "Sexy and simple python charting";
    homepage = "http://www.pygal.org";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sjourdois ];
  };

}
