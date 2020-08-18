{ stdenv, fetchPypi, python, buildPythonPackage
, matplotlib, jinja2
}:

buildPythonPackage rec {
  version = "0.3";
  pname = "mpld3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d455884a211bf99b37ecc760759435c7bb6a5955de47d8daf4967e301878ab7";
  };

  propagatedBuildInputs = [ matplotlib jinja2 ];
  # Tests disabled as they need a working X display
  doCheck = false;

  meta = with stdenv.lib; {
    description = "D3 Viewer for Matplotlib";
    homepage = "http://mpld3.github.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ unode ];
  };

}
