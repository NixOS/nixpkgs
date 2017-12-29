{ stdenv, buildPythonPackage, fetchPypi, blessings, mock, nose, pyte, pytest, wcwidth }:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.2.11";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vljmw3sy6lrqahhpyg4gk13mzcx3mwhvg8s41698ms3cpgkjipc";
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
