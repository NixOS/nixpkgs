{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "pycallgraph";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w8yr43scnckqcv5nbyd2dq4kpv74ai856lsdsf8iniik07jn9mi";
  };

  buildInputs = [ pytest ];

  # Tests do not work due to this bug: https://github.com/gak/pycallgraph/issues/118
  doCheck = false;

  meta = with lib; {
    homepage = "http://pycallgraph.slowchop.com";
    description = "Call graph visualizations for Python applications";
    maintainers = with maintainers; [ auntie ];
    license = licenses.gpl2;
  };

}
