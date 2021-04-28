{ lib, buildPythonPackage, fetchFromGitHub
, six
, pytest
, dateutil
}:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "javaproperties";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n6dz6rnpq8wdwqyxqwv0q7vrl26vfmvvysdjvy557fck1q2l0kf";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ dateutil pytest ];
  checkPhase = ''
    rm tox.ini
    pytest -k 'not dumps and not time' --ignore=test/test_propclass.py
  '';

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
