{ lib, buildPythonPackage, fetchFromGitLab, psutil, pytest }:

buildPythonPackage rec {
  pname = "pytest-memprof";
  version = "0.2.0";
  
  src = fetchFromGitLab {
    owner = "uweschmitt";
    repo = "pytest-memprof";
    # version 0.2.0 is not released on Gitlab
    rev = "5629cdfc0a0dd4667543c2b475630e51db616575";
    sha256 = "0gakn76apri95aa2n1krj1qp0i8mbzgmkaic09hxj3x2faj5i8n1";
  };
   
  propagatedBuildInputs = [ psutil ];

  checkInputs = [ pytest ];
  
  checkPhase = ''
    pytest tests
  '';
  
  meta = with lib; {
    description = "Estimates memory consumption of test functions";
    homepage = "https://gitlab.com/uweschmitt/pytest-memprof";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
