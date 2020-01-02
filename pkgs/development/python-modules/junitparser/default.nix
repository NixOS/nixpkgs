{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, python
}:

buildPythonPackage rec {
  pname = "junitparser";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "gastlygem";
    repo = pname;
    rev = version;
    sha256 = "16xwayr0rbp7xdg7bzmyf8s7al0dhkbmkcnil66ax7r8bznp5lmp";
  };

  propagatedBuildInputs = [ future ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "A JUnit/xUnit Result XML Parser";
    license = licenses.asl20;
    homepage = https://github.com/gastlygem/junitparser;
    maintainers = with maintainers; [ multun ];
  };
}
