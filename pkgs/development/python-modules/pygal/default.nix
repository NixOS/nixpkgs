{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, flask
, pyquery
, pytest
, cairosvg
, tinycss
, cssselect
, lxml
}:

buildPythonPackage rec {
  pname = "pygal";
  version = "2.3.1";

  doCheck = !isPyPy;  # one check fails with pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ba5a191233d0c2d8bf4b4d26b06e42bd77483a59ba7d3e5b884d81d1a870667";
  };

  buildInputs = [ flask pyquery pytest ];
  propagatedBuildInputs = [ cairosvg tinycss cssselect ]
    ++ stdenv.lib.optionals (!isPyPy) [ lxml ];

  meta = with stdenv.lib; {
    description = "Sexy and simple python charting";
    homepage = http://www.pygal.org;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sjourdois ];
  };

}
