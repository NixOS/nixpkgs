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
  version = "2.4.0";

  doCheck = !isPyPy; # one check fails with pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "9204f05380b02a8a32f9bf99d310b51aa2a932cba5b369f7a4dc3705f0a4ce83";
  };
  patches = [
    # Fixes compatibility with latest pytest. October 12, 2020.
    # Should be included in the next release after 2.4.0
    (fetchpatch {
      url = "https://github.com/Kozea/pygal/commit/19e5399be18a054b3b293f4a8a2777d2df4f9c18.patch";
      sha256 = "1j0hpcvd2mhi449wmlr0ml9gw4cakqk3av1j79bi2qy86dyrss2l";
    })
  ];

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
