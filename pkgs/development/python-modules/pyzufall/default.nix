{ lib, fetchPypi, python, buildPythonPackage, nose, future, coverage }:

buildPythonPackage rec {
  pname = "PyZufall";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jffhi20m82fdf78bjhncbdxkfzcskrlipxlrqq9741xdvrn14b5";
  };

  # disable tests due to problem with nose
  # https://github.com/nose-devs/nose/issues/1037
  doCheck = false;

  nativeCheckInputs = [ nose coverage ];
  propagatedBuildInputs = [ future ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = with lib; {
    homepage = "https://pyzufall.readthedocs.io/de/latest/";
    description = "Library for generating random data and sentences in german language";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ davidak ];
  };
}
