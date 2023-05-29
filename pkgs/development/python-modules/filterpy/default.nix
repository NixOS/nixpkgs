{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, matplotlib
, pytest
, isPy3k
}:

buildPythonPackage {
  version = "unstable-2022-08-23";
  pname = "filterpy";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "rlabbe";
    repo = "filterpy";
    rev = "3b51149ebcff0401ff1e10bf08ffca7b6bbc4a33";
    hash = "sha256-KuuVu0tqrmQuNKYmDmdy+TU6BnnhDxh4G8n9BGzjGag=";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib ];

  # single test fails (even on master branch of repository)
  # project does not use CI
  checkPhase = ''
    pytest --ignore=filterpy/common/tests/test_discretization.py
  '';

  meta = with lib; {
    homepage = "https://github.com/rlabbe/filterpy";
    description = "Kalman filtering and optimal estimation library";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
