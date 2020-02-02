{ stdenv
, buildPythonPackage
, fetchPypi
, squaremap
, wxPython
}:

buildPythonPackage rec {
  pname = "runsnakerun";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a66a0cdf0333dc3c0830c18e2f3d62f741dea197cd01a7e0059da4886a3a123f";
  };

  propagatedBuildInputs = [ squaremap wxPython ];

  meta = with stdenv.lib; {
    description = "GUI Viewer for Python profiling runs";
    homepage = http://www.vrplumber.com/programming/runsnakerun/;
    license = licenses.bsd3;
  };

}
