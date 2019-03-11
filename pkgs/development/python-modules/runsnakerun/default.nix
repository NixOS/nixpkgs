{ stdenv
, buildPythonPackage
, fetchPypi
, squaremap
, wxPython
}:

buildPythonPackage rec {
  pname = "runsnakerun";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61d03a13f1dcb3c1829f5a146da1fe0cc0e27947558a51e848b6d469902815ef";
  };

  propagatedBuildInputs = [ squaremap wxPython ];

  meta = with stdenv.lib; {
    description = "GUI Viewer for Python profiling runs";
    homepage = http://www.vrplumber.com/programming/runsnakerun/;
    license = licenses.bsd3;
  };

}
