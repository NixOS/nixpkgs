{ lib
, buildPythonPackage
, fetchFromGitHub
, simpleeval
, isPy27
, coveralls
}:

buildPythonPackage rec {
  pname = "casbin";
  version = "0.17.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = "pycasbin";
    rev = "v${version}";
    sha256 = "0cj1z5f78i4hp7jdwzny6gzf7brsglk1ahd04dawss7rn8s46282";
  };

  propagatedBuildInputs = [
    simpleeval
  ];

  checkInputs = [
    coveralls
  ];

  checkPhase = ''
    coverage run -m unittest discover -s tests -t tests
  '';

  meta = with lib; {
    description = "An authorization library that supports access control models like ACL, RBAC, ABAC in Python";
    homepage = "https://github.com/casbin/pycasbin";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
