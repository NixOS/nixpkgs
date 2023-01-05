{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "portolan";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fitnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zKloFO7uCLkqgayxC11JRfMpNxIR+UkT/Xabb9AH8To=";
  };

  pythonImportsCheck = [ "portolan" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/fitnr/portolan";
    license = licenses.gpl3;
    description = "Convert between compass points and degrees";
    maintainers = with maintainers; [ kevink ];
  };
}
