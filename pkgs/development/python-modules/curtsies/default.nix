{ stdenv, buildPythonPackage, fetchPypi, blessings, mock, nose, pyte, pytest, wcwidth }:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "89c802ec051d01dec6fc983e9856a3706e4ea8265d2940b1f6d504a9e26ed3a9";
  };

  propagatedBuildInputs = [ blessings wcwidth pyte ];

  checkInputs = [ nose mock pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = https://pypi.python.org/pypi/curtsies;
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
