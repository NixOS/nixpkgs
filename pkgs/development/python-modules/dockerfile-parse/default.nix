{ lib, buildPythonPackage, fetchFromGitHub, six, pytest-cov, pytest }:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "dockerfile-parse";

  src = fetchFromGitHub {
     owner = "DBuildService";
     repo = "dockerfile-parse";
     rev = "1.2.0";
     sha256 = "0mpgqvfn2h5ijl20ilvf4cbgqzl2y4crz33i32akjp18bf5kvffz";
  };

  postPatch = ''
    echo " " > tests/requirements.txt \
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest-cov pytest ];

  meta = with lib; {
    description = "Python library for parsing Dockerfile files";
    homepage = "https://github.com/DBuildService/dockerfile-parse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
