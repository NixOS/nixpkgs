{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "1.5";
  pname = "progress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wj3wvdgfmqj44n32wag3mzpp5fjqkkd321x67v1prxvs78yvv39";
  };

  checkPhase = ''
    ${python.interpreter} test_progress.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/verigak/progress/;
    description = "Easy to use progress bars";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
